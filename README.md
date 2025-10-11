# 📘 My APT Repository

**Author:** Syed Hamza Ali Shah
**Program:** Bachelor of Science in Information Technology (BSIT)  
**Batch:** 2023–2027  
**Institution:** Punjab University (Affiliated Colleges)

---

## 📖 Overview
This project is a **custom APT (Advanced Package Tool) repository** created for educational and experimental purposes.  
It demonstrates how to host, manage, and distribute Debian-based software packages through a personal repository.

The project also serves as part of my practical learning experience in Linux system administration, repository management, and package deployment.

## 🧠 DarkMatter APT Repository

Welcome to the **DarkMatter Custom APT Repository** — a personal Debian/Ubuntu package repository hosting custom `.deb` packages for easy installation and updates via `apt`.

---

### 📦 Add this repository

Run the following commands to add the DarkMatter APT repo to your system:

```bash
# 1️⃣ Add repository source
echo "deb [arch=amd64 trusted=yes] https://mrshah63.github.io/my-apt-repo stable main" | sudo tee /etc/apt/sources.list.d/darkmatter.list

# 2️⃣ Update package lists
sudo apt update
```

> 💡 You can remove `[trusted=yes]` if you add GPG signing later.

---

### 🚀 Install Packages

After updating, install any package from the repo with:

```bash
sudo apt install <package-name>
```

Example:

```bash
sudo apt install anydesk
```

---

### 🧰 Repository Structure

```
my-apt-repo/
├── pool/
│   └── main/                # Stores .deb packages
│       ├── anydesk_6.4.0-1_amd64.deb
│       └── ocs-url_3.1.0-0ubuntu1_amd64.deb
├── dists/
│   └── stable/
│       ├── main/
│       │   └── binary-amd64/
│       │       ├── Packages
│       │       └── Packages.gz
│       └── Release
├── update-repo.sh           # Auto script to rebuild and push metadata
└── README.md
```

---

### ⚙️ How to Add New Packages

When you add or update a `.deb` file in `pool/main/`, just run:

```bash
./update-repo.sh
```

The script will automatically:

* Rebuild `Packages` and `Release` files
* Add necessary metadata (Origin, Label, etc.)
* Commit and push updates to GitHub Pages

---

### 🔧 Host on GitHub Pages

To make your repo accessible via `https://username.github.io/my-apt-repo`:

1. Go to **GitHub → Settings → Pages**
2. Under **Source**, select:

   * **Branch:** `main`
   * **Folder:** `/ (root)`
3. Save the settings.

GitHub will publish your APT repo within a few minutes.

---

### 🧩 Troubleshooting

| Problem                                                    | Solution                                                                  |
| ---------------------------------------------------------- | ------------------------------------------------------------------------- |
| `W: Conflicting distribution (expected stable but got '')` | Run `./update-repo.sh` to regenerate metadata properly                    |
| `No Hash entry in Release file`                            | Your Release file is missing hashes — the script fixes this automatically |
| `Ign: stable Release.gpg`                                  | Not an error unless you're enforcing GPG signing                          |

---

### 🛠️ Requirements

* Ubuntu / Debian system
* `apt-ftparchive` (from `apt-utils` package)
* `git` (for committing/pushing)
* GitHub Pages enabled

---

### 📜 License

This project is open-source under the **MIT License**.
Use, modify, and distribute freely with proper attribution.

---

### 👨‍💻 Author

**DarkMatter (Mr. Shah)**
📍 Custom Linux & APT Repo Builder
🔗 [GitHub Profile](https://github.com/mrshah63)

