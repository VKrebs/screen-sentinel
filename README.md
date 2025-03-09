# 🛡️ Screen Sentinel  

**A personal challenge to build a tamper-resistant Windows lock screen overlay.**    

---

## 🔍 About  

**Screen Sentinel** is an **experimental project** aimed at creating a **secure, transparent lock screen overlay** for Windows. The (unoriginal) idea is simple:  

- Lock down all user interaction **while keeping the screen visible**.  
- Persist as a **Windows Service** to prevent easy termination.  
- **Enforce system restrictions** (disable Task Manager, prevent process launches, etc.).  
- **Log access attempts** and system events for security tracking.  

Right now, **this is a personal project**, **not a commercial-grade solution**. Expect **experimentation, work-in-progress code**, and possibly some fun security challenges along the way! 😃  

---

## ⚡ Features (Planned & In Progress)  

🚧 **Transparent lock UI** – Block input while keeping the desktop visible.  
🚧 **Windows Service integration** – Ensures persistence on startup.  
🚧 **Security restrictions** – Disable Task Manager, Explorer, etc.  
🚧 **Tamper resistance** – Prevent process termination and work around `Ctrl+Alt+Del`.  
🚧 **Authentication methods** – Start with password, later explore EntraID, biometrics or hardware unlock.  
🚧 **Audit logging** – Log access attempts and security events to Windows Event Log.  

---

## 🎯 Goals & Challenges  

This project is **more of a challenge than a product**. Some things I’m exploring:  

- **Windows APIs & Security:** `CreateProcessAsUser`, privilege escalation, and system restrictions.  
- **Process & Service Management:** How to make a persistent watchdog for a security app.  
- **Bypass Prevention:** Understanding what users *can* and *can’t* do when trying to escape the lock.  
- **Logging & Auditing:** How to track security events effectively.  

If you're interested in **low-level Windows hacking**, **security engineering**, or **kiosk-like system lockdowns**, this might be for you!  

---

## 🛠️ Setup & Running (WIP)  

⚠️ **Warning:** This is an early-stage project and may break things. Use with caution.  

### **Requirements**  
- Windows 10 or 11  
- .NET (for the service and UI)  

### **Running the Project**  
*(Steps will be added as development progresses!)*  

---

## 🗺️ Roadmap  

🔹 **Phase 1:** Core functionality – lock UI, input blocking, simple service.  
🔹 **Phase 2:** Process hardening – prevent termination, restrict system features.  
🔹 **Phase 3:** Authentication methods – password, EntraID, biometrics, etc.  
🔹 **Phase 4:** Logging & security auditing.  
🔹 **Phase 5:** (Maybe) More advanced security enhancements.  

---

## 🤝 Contributions & Feedback  

Since this is an **exploratory project**, I welcome **ideas, feedback, and discussions!**   
If you have insights on **Windows security, system lockdown techniques, or general improvements**, feel free to open an issue or share thoughts.   

For now, this is a personal project, so **contributions are informal**, but if things evolve, I may open it up more!  

---

## 📜 License  

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.  

---

## 📢 Disclaimer  

This is a **learning project**, not an enterprise security solution. **Use at your own risk** – it might have **security flaws, incomplete features, or bugs**. If you find a cool bypass, let me know! 😃  
