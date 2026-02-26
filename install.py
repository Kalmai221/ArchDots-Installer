import os
import shutil
import subprocess
import requests
from pathlib import Path
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, DownloadColumn
from rich.panel import Panel
from rich.prompt import Confirm

console = Console()

# --- CONFIGURATION ---
WP_URL = "https://4kwallpapers.com/images/wallpapers/blue-abstract-3840x2160-25121.jpg"
WP_DIR = Path.home() / "Pictures/Wallpapers"
WP_PATH = WP_DIR / "blue-abstract.jpg"
SCRIPT_DIR = Path(__file__).parent.absolute()

def run_cmd(cmd, sudo=False, capture=True):
    """Executes shell commands with optional sudo."""
    prefix = "sudo " if sudo else ""
    full_cmd = f"{prefix}{cmd}"
    try:
        if capture:
            subprocess.run(full_cmd, shell=True, check=True, capture_output=True, text=True, executable="/bin/bash")
        else:
            subprocess.run(full_cmd, shell=True, check=True, executable="/bin/bash")
        return True
    except subprocess.CalledProcessError as e:
        console.print(f"[bold red]Error:[/bold red] {cmd}\n[red]{e.stderr if capture else ''}[/red]")
        return False

def download_wallpaper():
    """Downloads wallpaper with browser spoofing and a Rich progress bar."""
    WP_DIR.mkdir(parents=True, exist_ok=True)
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"}
    
    try:
        response = requests.get(WP_URL, headers=headers, stream=True)
        total_size = int(response.headers.get('content-length', 0))
        
        with Progress(
            TextColumn("[bold blue]{task.description}"),
            BarColumn(bar_width=None),
            DownloadColumn(),
            transient=True,
        ) as progress:
            task = progress.add_task("Downloading 4K Wallpaper...", total=total_size)
            with open(WP_PATH, 'wb') as f:
                for data in response.iter_content(chunk_size=1024):
                    f.write(data)
                    progress.update(task, advance=len(data))
        return True
    except Exception as e:
        console.print(f"[red]Download failed: {e}[/red]")
        return False

def main():
    console.print(Panel.fit("[bold cyan]🚀 Modern Arch Dots Installer[/bold cyan]", border_style="blue", padding=(1, 2)))

    # 1. System Prep & Core Apps
    with console.status("[bold green]Updating system and installing base-devel & btop...") as status:
        run_cmd("pacman -Syu --noconfirm git base-devel btop code", sudo=True)
    console.print("✅ Core system packages and [bold]btop/code[/bold] installed.")

    # 1.5 AUR Helper (yay) and Edge
    if not shutil.which("yay"):
        console.print("[bold yellow]Installing yay (AUR Helper)...[/bold yellow]")
        run_cmd("git clone https://aur.archlinux.org/yay.git")
        os.chdir("yay")
        run_cmd("makepkg -si --noconfirm")
        os.chdir("..")
        shutil.rmtree("yay")
    
    with console.status("[bold cyan]Installing Microsoft Edge via yay...") as status:
        run_cmd("yay -S --noconfirm microsoft-edge-stable-bin")
    console.print("✅ Microsoft Edge installed.")

    # 2. Hyprland Dots (Interactive)
    console.print("[bold yellow]Starting end-4 dotfiles installation...[/bold yellow]")
    run_cmd("bash <(curl -s https://ii.clsty.link/get)", capture=False)

    # 3. Keyboard Config
    hypr_conf = Path.home() / ".config/hypr/hyprland.conf"
    if hypr_conf.exists():
        with open(hypr_conf, "a") as f:
            f.write("\ninput {\n    kb_layout = gb\n}\n")
        console.print("✅ Keyboard layout set to [bold]GB[/bold].")

    # 4. Wallpaper
    if download_wallpaper():
        console.print(f"✅ Wallpaper saved to [italic]{WP_PATH}[/italic]")

    # 5. Config Deployment
    local_conf = SCRIPT_DIR / "illogical-impulse/config.json"
    target_dir = Path.home() / ".config/illogical-impulse"
    if local_conf.exists():
        target_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy(local_conf, target_dir / "config.json")
        conf_file = target_dir / "config.json"
        # Using a more robust replace for the home directory path if needed
        content = conf_file.read_text().replace('"/home/kalmai221/Downloads/blue-abstract-3840x2160-25121.jpg"', f'"{WP_PATH}"')
        conf_file.write_text(content)
        console.print("✅ illogical-impulse config deployed.")

    # 6. SDDM Customization
    with console.status("[bold magenta]Installing SilentSDDM Theme...") as status:
        if Path("SilentSDDM").exists(): shutil.rmtree("SilentSDDM")
        run_cmd("git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM")
        os.chdir("SilentSDDM")
        run_cmd("chmod +x install.sh && sudo ./install.sh")
        os.chdir("..")

        local_sddm = SCRIPT_DIR / "sddm/default.conf"
        if local_sddm.exists():
            run_cmd(f"cp {local_sddm} /usr/share/sddm/themes/silent/configs/default.conf", sudo=True)
        
        run_cmd(f"mkdir -p /usr/share/sddm/themes/silent/backgrounds/", sudo=True)
        run_cmd(f"cp {WP_PATH} /usr/share/sddm/themes/silent/backgrounds/", sudo=True)
    console.print("✅ SDDM Theme and Config applied.")

    # 7. Final Polish
    if shutil.which("swww"):
        run_cmd("pgrep -x swww-daemon || swww-daemon &")
        run_cmd(f"swww img {WP_PATH} --transition-type grow")
        console.print("🖼️  Wallpaper set live.")

    console.print(Panel("[bold green]✨ Setup Complete! Enjoy your new desktop.[/bold green]", border_style="green"))

if __name__ == "__main__":
    main()