
A full backup & restoration plan should also include the configuration of applications that were just installed by the Boxstarter script, such as importing bookmarks, setting themes, adding email accounts, etc.; and OS customizations that cannot be performed by Boxstarter, such as customizing the Taskbar, Start Menu, Desktop, etc.

[Which Files Should You Back Up On Your Windows PC?](https://www.howtogeek.com/howto/30173/what-files-should-you-backup-on-your-windows-pc/)

[How to Use All of Windows 10’s Backup and Recovery Tools](https://www.howtogeek.com/220986/how-to-use-all-of-windows-10%E2%80%99s-backup-and-recovery-tools/)

### Full Backup & Restoration Plan: (Example)
 
**Note:** It is good practice to choose a new login password after every fresh install, assume the old password has been comprimised.
 
- Windows Installer image: ISO, DVD, Bootable USB
- Windows Product Key, Windows Edition (Take a picture of Product Key stickers early on, since they tend to fade or get rubbed off. Even if that happens, they can still be recovered by 3rd-party software tools like ["The Magical Jelly Bean Keyfinder"](https://chocolatey.org/packages/keyfinder). Just make sure you use tools such as these [at your own risk.](https://www.virustotal.com/gui/file/35e605862069aeb3d8413cd512ae05f2831f21f1f496c9cdb90d1c3b8a3cfb97/detection))
   - Microsoft Office Product Key(s)
   - Other paid-for software Product Keys & Installers. E.g. Adobe Acrobat, Photoshop, etc.
- Connect to Network:
   - Wi-Fi password
   - Join Domain (if applicable)
- BoxstarterInstall-script.txt
   - Download & Install all Windows Updates
   - [Configure OS](https://boxstarter.org/WinConfig) (as much as possible with available Boxstarter tools)
   - Download & Install software via [Chocolatey](https://chocolatey.org/)
   - [Custom Chocolatey packages](https://chocolatey.org/docs/create-packages) (for rare software, or software not listed in the [Chocolatey community repository](https://chocolatey.org/packages))
- App configuration:
   - Internet Browsers
     - Bookmarks
     - Add-ons/Plugins/Extensions list
       - NoScript Whitelist
     - Customize: organize toolbars
     - Options
       - General -> Startup -> Restore previous session
       - General -> Tabs -> Ctrl+Tab cycles through tabs in recently used order (If turned On, Ctrl+Shift+Tab has a [different function](https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly?redirectlocale=en-US&redirectslug=Keyboard+shortcuts#w_windows-tabs))
   - Email Client
     - Email accounts list
     - Message Filters/Rules
   - KeePass
     - Plugins list
   - Notepad++/IDE of choice
     - Theme: (Settings -> Style Configurator -> Select theme: "Obsidian")
- Firmware Updates/Hardware Tweaks
   - Check if things like [TPM firmware](https://support.microsoft.com/en-us/help/4096377/windows-10-update-security-processor-tpm-firmware#firmwareupdates) or BIOS/UEFI firmware requires security updates (services like Windows Message Center, Windows Defender, or your 3rd-party Anti-Virus *should* automatically detect and notify you if necessary, but it is always wise to check for yourself).
- OS customizations:
   - Taskbar
   - Start Menu
   - Desktop
- Data Files:
   - %UserProfile%\\\* (C:\Users\\*{username}*\\*)
   - %UserProfile%\Documents
   - %UserProfile%\Desktop
   - %UserProfile%\Downloads
   - %UserProfile%\Pictures
   - %AppData%\\\* (C:\Users\\*{username}*\AppData\Roaming\\\*)
   - %LocalAppData%\\\* (C:\Users\\*{username}*\AppData\Local\\\*)
   - %AllUsersProfile%\\\* (C:\ProgramData\\\*)
   - D:\\\*
 
**FYI:** Of course, you can always use the [built-in Windows backup tools](https://support.microsoft.com/en-us/help/17127/windows-back-up-restore) to create a full system image for a backup. 

Some reasons you might want to use this method instead is it is repeatable across practically any type of computer hardware. Say, if your motherboard & CPU had to be replaced, the hardware drivers saved in a **system image** backup might not work with the new hardware. Even if your 32-bit laptop crashed, but if it was backed-up using this method, you could restore your same environment to a 64-bit desktop with completely different hardware, and the correct x64/x86 versions of software installs will be handled automatically by [chocolatey](https://chocolatey.org/). The storage size of backups will be much smaller, and could be scanned for viruses before restoring data from them. With compression, you could store many more copies of backups than with system images.

The cons of this method are: #1 it takes more work to prepare, and more work to maintain. And #2: if you have any legacy applications that **REQUIRE** a certain version of an application to be functional, a *full system image* will restore that. However, keep in mind, Chocolatey has functionality to install specific versions of software, and you have the ability to create custom Chocolatey packages.

**Method 1: Windows Image backup**

Pros | Cons
--- | ---
| Easy & Simple to use. Can be as simple as 1-click to backup. | Large Backup file size. A system image will be close to the size of the used space on the disk. Backup drive should be at least 2x the size capacity of original drive. |
| Built-in Microsoft Windows tool. | Proprietary format. Must use the same tool to restore from backup. |
| Fast recovery time. | Slow backup time. |
|  | Impossible to access backup files individually from a proprietary archive without recovering them to main drive first. |
|  | Difficult or Impossible to recover to a different set of hardware. |
|  | Still requires a Windows Installer ISO/DVD/USB & Product Key backups for severe system failures. |
|  | Corrupted backup files may be impossible to recover any data from. |
|  | Viruses will remain intact in backup files, and will get restored when backup is restored. |

**Method 2: Separate Data backup**

Pros | Cons
--- | ---
| Can recover to any type of hardware. A 32-bit laptop backup can be recovered to a 64-bit desktop. | Boxstarter script must be updated any time new software is installed. |
| [Incremental & Differential](https://www.backup-utility.com/windows-10/incremental-and-differential-backup-windows-10-1128.html) [(2)](https://www.acronis.com/en-us/blog/posts/tips-tricks-better-business-backup-and-recovery-world-backup-day) backups become possible. | If software is not already in the [Chocolatey community repository](https://chocolatey.org/packages), you must [create your own Chocolatey package](https://chocolatey.org/docs/create-packages) if you wish to use that method to install. |
| Any type of file transfer tool can be used to perform backups, e.g. `xcopy`, `robocopy`, [`rsync`](https://chocolatey.org/packages/rsync), [RichCopy](https://social.technet.microsoft.com/Forums/windows/en-US/33971726-eeb7-4452-bebf-02ed6518743e/microsoft-richcopy), etc. | Initial backup takes more time to prepare. Especially if application configuration & customization is considered. |
| Backup files can be inspected & restored individually. | Automated backups are more manual & usually rely on custom scripts to copy, compress, encrypt, & rename backup files. |
| Tough-to-remove Viruses & Malware such as Rootkits and Zero-days get wiped out during recovery by nature of a fresh Windows re-install. | Restoration from backup takes more time & requires more steps due to fresh Windows re-install.
| Backup sizes are much smaller, taking less time to complete & allowing for more backup copies to be stored. |  |
| Backups can still be compressed using Window-native file formats (\*.zip) to save even more file space, & can be inspected while compressed. |  |
| Backup files can be virus-scanned without any special tools or methods. |  |

## Windows Installers:

Unfortunately most new computers do not come with a Windows installer disk anymore. The ISOs of disks are hosted by Microsoft:

[Download Windows 10 ISO](https://www.microsoft.com/en-in/software-download/windows10)

[Download Windows 8.1 ISO](https://www.microsoft.com/en-in/software-download/windows8ISO)

[Download Windows 7 ISO](https://www.microsoft.com/en-in/software-download/windows7)

Keeping a copy of the ISOs on your backup drive works fine, as long as you have more than one PC that can access it.

It is always wise to test your backup solution before needing to use it for recovery. Making a DVD or bootable USB drive from that ISO ASAP allows you to test and verify you have a working physical installer, before a severe failure happens.

## How to Contribute:

Just like the rest of this repository, all contributions & corrections are welcome. 

**To make the changes yourself**, the natural Git way to do it is to [fork this repository](https://help.github.com/en/articles/fork-a-repo), make your changes, then [create a pull request](https://help.github.com/en/articles/creating-a-pull-request-from-a-fork) to have your changes pulled into this project for everyone to enjoy.

If you don't already have it installed, a git GUI such as **GitHub Desktop** can be installed [automatically via Chocolately](https://chocolatey.org/packages/github-desktop) or [manually on your own](https://desktop.github.com/).



**To request that somebody else make the changes**, just [submit an issue](https://github.com/Kerbalnut/Batch-Tools-SysAdmin/issues) to this repository and anyone who wants to can assign themselves to take care of it!