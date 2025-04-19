# VProbe
VProbe is a lightweight, PowerShell-based TCP and HTTP port scanner designed to work even in **Constrained Language Mode** or **restricted Windows environments**.

##🔍 Features
- 🔐 No admin privileges needed
- 📊 Output to clean CSV format
- 🎯 Supports manual input of targets and ports
- ⚡ Instant results with color-coded output
A custom Powerful Window based script to scan for live IPs and detect open ports, similar to the Linux-based HTTProbe tool on GitHub.

I created a custom PowerShell script designed to evade antivirus detection on Windows systems while performing tasks such as scanning live IPs, detecting open ports, and documenting the scan results in an Excel sheet.

## ⚙️ Usage
```powershell
# Run the script
powershell -ExecutionPolicy Bypass -File .\VProbe.ps1
```
1.Run the script
 >./Win_httpProbe

2. You'll be prompted to enter:
- Target(s): `google.com, 8.8.8.8`
- Port(s): `80,443`

POC:
![POC](https://github.com/user-attachments/assets/e91be192-c086-4861-bb2e-4119b73bc8f7)

![1](https://github.com/user-attachments/assets/ee5f1e77-bf6b-4c37-8d2c-94ae9e42d384)

![2](https://github.com/user-attachments/assets/2d4abc86-7aa3-49a1-b10b-9ff2467f8a81)

Best regards,
Viraj Mota
https://in.linkedin.com/in/viraj-mota



## 📝 License
Licensed under the [Apache 2.0 License](LICENSE).  
See the [NOTICE](NOTICE) file for attribution.

## 👤 Author
Created by **Viraj Mota**  
[GitHub](https://github.com/VirajRecon) • [LinkedIn](https://linkedin.com/in/virajmota)
