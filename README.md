## Update (Dated 21/02/2026 - IST)

**_Binaries have been removed, as this is an experimental, unofficial fork used for learning and portability testing. Programming is about understanding logic and implementing it securely, not just getting outputs, and vibe-coding tools become dangerous when they are used to replace comprehension instead of supporting it.  If you choose to experiment with this code, please do read the potential vulnerabilities (listed at the end of the readme file), and try at your own discretion and risk._** 

---


<div align="center">
  <img src="assets/logo.jpg" alt="PicoClaw" width="512">

  <h1>PicoClaw: Ultra-Efficient AI Assistant in Go</h1>

  <h3>Runs in 32-bit Windows 10 · 1s Boot</h3>

</div>

- If you want to know how Picoclaw works, refer the original repository's `readme.md` [file](https://github.com/sipeed/picoclaw/blob/main/README.md).

---

> ⚠️ **CAUTION** ⚠️ - This is an experimental fork intended for learning purposes. Review and understand the source before building or running it.

Thanks to vibe coding, some curiosity, and patience, I managed to port PicoClaw to a low-end laptop, and it works but hasn't undergone extensive security review.

I initially tried compiling directly on the target machine, which turned out to be *really* slow, so most of the heavy lifting was done on a faster computer.

---

### Target System
- **OS:** Windows 10 x86 (Build 1803)
- **Architecture:** 32-bit (x86)
- **Storage:** 32 GB
- **RAM:** 2 GB

---

### What I Used
- Latest PicoClaw source code release — **v0.1.2**
- Go 1.26.0 (x86)
- gcc-15.2.0-mingw-w64ucrt-13.0.0-r5 (from winlibs.org)
- A faster computer to compile PicoClaw
- **For coding:** Claude, GitHub Copilot, Gemini and ChatGPT

---

### How to Compile Binaries
- Decompress `picoclaw-0.1.2.zip`, to a folder. 
- Now, open a terminal in that decompressed path, and type `SET GOARCH=386` and  `SET GOOS=WINDOWS`. 
- Next, to build the source code type `mingw32-make build` and which would build the 32-bit ex, after the build is done. 
- Navigate to the build folder, and open a terminal in that path, and test it out by:
	- For **Powershell**: d`./picoclaw-windows-386`
	- For **Command Prompt**: `picoclaw-windows-386`
- To run this properly, add `picoclaw.exe` to your **PATH** under **System Variables**.
- After that, you can run it from **any directory** in a terminal.

---

### Notes
- This is an **experimental** port
- No extensive testing was done
- Stability and performance are not guaranteed
- Proceed at your own risk

---

### Potential Vulnerabilities (Referred from [A Picoclaw Can Compromise Your Entire System](https://dev.to/jxlee007/a-picoclaw-can-compromise-your-entire-system-11l7)) :

- Command Injection: The agent has a "shell tool" that executes commands on your computer. Sounds handy for automating tasks.
- Path Traversal: The file system tool lets the AI read and write files. But it doesn't check WHICH files. 
- Plaintext Secrets: All API keys, bot tokens, and passwords are stored in a JSON file. Unencrypted.
