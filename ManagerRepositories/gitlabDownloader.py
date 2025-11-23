import gitlab
import os
import subprocess

# GitLab configuration
GITLAB_URL = "https://gitlab.abastible.cl"  # Change if using a self-hosted GitLab
ACCESS_TOKEN = "TxY4jHdgbsM2J1XDNQVj"
CLONE_DIR = "D:\Backup\develop\prodigio"  # Change if needed
PREFERRED_BRANCH = "develop"  # Preferred branch
# Initialize GitLab connection
gl = gitlab.Gitlab(GITLAB_URL, private_token=ACCESS_TOKEN)
gl.auth()

# Create a directory for repositories if it doesn't exist
os.makedirs(CLONE_DIR, exist_ok=True)

# Create a directory for repositories if it doesn't exist
os.makedirs(CLONE_DIR, exist_ok=True)

def get_group_projects(group_id):
    """Fetches all projects from a given GitLab group (including subgroups)."""
    group = gl.groups.get(group_id)
    projects = group.projects.list(all=True)
    return projects

def get_available_branches(repo_path):
    """Fetch all branches using Git and return a list of available branches."""
    try:
        subprocess.run(["git", "-C", repo_path, "fetch", "--all"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        result = subprocess.run(["git", "-C", repo_path, "branch", "-r"], capture_output=True, text=True, check=True)
        branches = [line.strip().split("/")[-1] for line in result.stdout.split("\n") if "origin" in line]
        return branches
    except subprocess.CalledProcessError:
        return []
# Fetch all groups where the user has access
groups = gl.groups.list(all=True)

all_projects = []

# Get projects from all groups
for group in groups:
    print(f"Fetching projects from group: {group.name}")
    all_projects.extend(get_group_projects(group.id))

# Get projects from all groups
for project in all_projects:
    repo_url = project.http_url_to_repo.replace("https://", f"https://oauth2:{ACCESS_TOKEN}@")
    repo_name = project.path
    repo_path = os.path.join(CLONE_DIR, repo_name)

    # Get available branches from GitLab API
    branches = get_available_branches(repo_path)
    print(repo_path)
    print(branches)

    # Select the correct branch
    if PREFERRED_BRANCH in branches:
        branch_to_use = PREFERRED_BRANCH
    else:
        branch_to_use = project.default_branch if project.default_branch else branches[
            0]  # Use default or first available branch

    if os.path.exists(repo_path):
        print(f"Updating {repo_name}...")
        subprocess.run(["git", "-C", repo_path, "fetch", "--all"], check=True)
        subprocess.run(["git", "-C", repo_path, "checkout", branch_to_use], check=True)
        subprocess.run(["git", "-C", repo_path, "pull", "origin", branch_to_use], check=True)
    else:
        print(f"Cloning {repo_name} on branch {branch_to_use}...")
        subprocess.run(["git", "clone", "-b", branch_to_use, repo_url, repo_path], check=True)

print("All repositories downloaded and switched to the correct branch successfully.")
