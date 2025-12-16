import os
import subprocess
import sys

try:
    import win32com.client  # for PowerPoint
except ImportError:
    win32com = None
    print("Warning: pywin32 (win32com) not installed. PPT/PPTX files will not be converted.")


# === CONFIG: change this to your folder ===
BASE_FOLDER = r"P:\langara\term 2\CPSC-4810-M01"
# ==========================================


def convert_ipynb_to_pdf(ipynb_path: str):
    """Convert a Jupyter notebook to PDF using nbconvert."""
    folder = os.path.dirname(ipynb_path)
    filename_no_ext = os.path.splitext(os.path.basename(ipynb_path))[0]
    print(f"[IPYNB] Converting: {ipynb_path}")

    # Output PDF will be <same_name>.pdf in the same folder
    cmd = [
        sys.executable, "-m", "jupyter",
        "nbconvert",
        "--to", "pdf",
        "--output", filename_no_ext,
        "--output-dir", folder,
        ipynb_path,
    ]

    try:
        subprocess.run(cmd, check=True)
        print(f"[IPYNB] OK -> {os.path.join(folder, filename_no_ext + '.pdf')}")
    except subprocess.CalledProcessError as e:
        print(f"[IPYNB] ERROR converting {ipynb_path}: {e}")


def convert_ppt_to_pdf(ppt_paths):
    """Convert a list of PPT/PPTX files to PDF using PowerPoint."""
    if win32com is None:
        print("Skipping PPT/PPTX conversion because win32com is not available.")
        return

    if not ppt_paths:
        return

    print("Starting PowerPoint...")
    powerpoint = win32com.client.Dispatch("PowerPoint.Application")
    powerpoint.Visible = 1  # or 0 to hide window

    # 32 is the constant ppSaveAsPDF
    ppSaveAsPDF = 32

    for ppt_path in ppt_paths:
        folder = os.path.dirname(ppt_path)
        filename_no_ext = os.path.splitext(os.path.basename(ppt_path))[0]
        pdf_path = os.path.join(folder, filename_no_ext + ".pdf")

        print(f"[PPT ] Converting: {ppt_path}")

        try:
            presentation = powerpoint.Presentations.Open(ppt_path, WithWindow=False)
            presentation.SaveAs(pdf_path, ppSaveAsPDF)
            presentation.Close()
            print(f"[PPT ] OK -> {pdf_path}")
        except Exception as e:
            print(f"[PPT ] ERROR converting {ppt_path}: {e}")

    powerpoint.Quit()


def main():
    ipynb_files = []
    ppt_files = []

    # Walk folder (no subfolders? you can remove os.walk and just listdir)
    for root, _, files in os.walk(BASE_FOLDER):
        for f in files:
            lower = f.lower()
            full_path = os.path.join(root, f)

            if lower.endswith(".ipynb"):
                ipynb_files.append(full_path)
            elif lower.endswith(".ppt") or lower.endswith(".pptx"):
                ppt_files.append(full_path)

    print(f"Found {len(ipynb_files)} notebooks and {len(ppt_files)} PPT/PPTX files.\n")

    for nb in ipynb_files:
        convert_ipynb_to_pdf(nb)

    # convert_ppt_to_pdf(ppt_files)

    print("\nDone.")


if __name__ == "__main__":
    main()
