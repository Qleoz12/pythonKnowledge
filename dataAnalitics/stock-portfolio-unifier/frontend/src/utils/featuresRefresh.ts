import { fetchFeaturesRefreshStatus, enrichFiltered } from '../services/api'

const SESSION_COOLDOWN_MS = 90_000
const STORAGE_KEY = 'spf_last_features_auto_batch_ts'

/** True if the newest feature row is older than `hours` (dataset considered stale). */
export function isMaxFeatureAgeBeyondHours(maxIso: string | null, hours: number): boolean {
  if (!maxIso) return true
  const ts = Date.parse(maxIso)
  if (Number.isNaN(ts)) return true
  return Date.now() - ts > hours * 3600 * 1000
}

/**
 * If feature data is older than `hours` (by max updated_at), run one forced batch refresh
 * (default 1000, stale-first) and invoke `reload`. Uses session cooldown to avoid duplicate
 * calls (e.g. Vue dev double mount).
 */
export async function maybeAutoRefreshStaleFeatures(
  reload: () => Promise<void>,
  options: {
    hours?: number
    batchSize?: number
    cooldownMs?: number
    /** Optional: same shape as enrichFiltered — scopes auto-refresh (e.g. Score vs trend filters). */
    enrichParams?: Record<string, string | number | boolean | null | undefined>
  } = {},
): Promise<{ ran: boolean; status?: Awaited<ReturnType<typeof fetchFeaturesRefreshStatus>>; error?: string }> {
  const hours = options.hours ?? 24
  const batchSize = options.batchSize ?? 1000
  const cooldownMs = options.cooldownMs ?? SESSION_COOLDOWN_MS

  let status: Awaited<ReturnType<typeof fetchFeaturesRefreshStatus>>
  try {
    status = await fetchFeaturesRefreshStatus(hours)
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : 'refresh-status failed'
    return { ran: false, error: msg }
  }

  if (!isMaxFeatureAgeBeyondHours(status.max_updated_at, hours)) {
    return { ran: false, status }
  }

  const last = Number(sessionStorage.getItem(STORAGE_KEY) || 0)
  if (Date.now() - last < cooldownMs) {
    return { ran: false, status }
  }

  try {
    await enrichFiltered({
      force: true,
      batch_size: batchSize,
      stale_first: true,
      offset: 0,
      ...(options.enrichParams ?? {}),
    })
    sessionStorage.setItem(STORAGE_KEY, String(Date.now()))
    await reload()
    return { ran: true, status }
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : 'enrich batch failed'
    return { ran: false, status, error: msg }
  }
}
