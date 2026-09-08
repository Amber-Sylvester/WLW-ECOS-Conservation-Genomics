# Week One
# Week Two
## Wildcards
| Wildcard | Meaning | Example |
| --- | --- | --- |
| * | Any number of these char. | *.txt |
| ? | Exactly one char. | ?.txt |
| [abc] | One of these char. | [abc].txt |
| [1-5] | Char. range | [1-5].txt |
| [a-z] | Letter range | [a-z].txt |
| [!abc] | Anything except these | [!abc].txt |
## Command History
- Up Arrow = Go back to the most recent cmd
- Down Arrow = Go forward in cmd history
- Ctrl + C = Cancel the cmd you are writing, and give you a fresh prompt
- Ctrl + R = Reverse search through cmd history
- Ctrl + L = Clear your screen
- history = Review recent cmd's
### History list is numbered, so you can reuse a cmd by referring to its number (Eg. !260)
## Examining Files
- cat = "Show me what's in this file"
- less = Show me one screen at a time
### While in less:
- Space = Go forward
- b = Go backwards
- g = Go to beginning
- G = Go to end
- q = quit
### You can also search for words by typing "/" and the word you are searching for 
- head = Show me the first 10 lines
- tail = Show me the last 10 lines
### Or -n to choose how many lines are shown (eg. head -20)
## Details on the FASTQ Format
### FASTQ = Sequence & quality info.
| Line | What it Contains |
| --- | --- |
| @read001 | Read ID/name |
| ACGTACGTAGCT | DNA sequence |
| + | Separator |
| IIIIIIIIIIII | Quality scores |
### Quality Scores:
| Symbol | Phred Score | Approx. Accuracy | Meaning |
| --- | --- | --- | --- |
| ! | 0 | 50% | Very Poor |
| " | 1 | 60% | Very Poor |
| # | 2 | 63% | Very Poor |
| + | 10 | 90% | Low |
| 5 | 20 | 99% | Acceptable |
| ? | 30 | 99.9% | Good |
| I | 40 | 99.99% | Very Good |
| S | 50 | 99.999% | Extremely Good |
## Creating, Moving, Copying, and Removing
- cp = Copy
- mkdir = Make directory
- mv = Move/rename
- ls = List
- -l = Current perms.
- chmod = Change perms.
- rm = remove
### In Perms:
- R = Read
- W = Write
- X = Execute
## Redirections
- grep = Search for information within a file
- for = Runs the same cmd for several input files
- command > file = Redirects a cmd's output to a file
- command >> file = Redirects a cmd's output to a file without overwriting the existing contents of a file
- command_1 | command_2 = Redirects the output of the first cmd as input to the second cmd
- basename = Gets rid of repetitive parts of names
## Redirecting Output
- wc = Word Count
- -l = Lines
## Writing for Loops
- ; = Separate two cmd's written on a single line
- do = The code that you want to execute in a loop
- done = Ends a loop
## Accessing Remote Computers
### SSH (Secure Shell)
#### - SSH = Secure Shell
- It is the main protocol used to access remote computers/servers.
- SSH creates an encrypted connection between your computer and the remote computer.
- You usually log in using:
  - Username
  - Password
  - Sometimes two-factor authentication (2FA).
Basic SSH command: ssh username@remote-server
### Remote Computing Clusters
The material discusses three main clusters:
#### - Hummingbird (UCSC)
  - Available to UCSC users with a UCSC Blue username/password.
  - If you're off campus, you need the UCSC VPN.
  - Uses tcsh by default.
  - You can configure it to automatically switch to bash.
#### - Alpine/Summit
  - Requires an appropriate university account.
  - Uses Duo for two-factor authentication.
  - You can create an alias to make logging in easier.
#### - Sedna (NMFS)
  - Only available to authorized NMFS employees.
  - Must be on the NMFS network or connected through VPN.
  - Example: username@sedna.nwfsc2.noaa.gov
### Windows
- Windows users can use SSH through Git Bash
- PuTTY is recommended as a dedicated SSH/terminal program
- MobaXterm is another option for connecting to remote servers
### Hummingbird Configuration
- Hummingbird uses tcsh instead of bash by default
### Alpine Login Shortcut
- You can create an alias in .bashrc: alias summit='ssh username@remote-server'
- You only need to type summit instead of the full SSH cmd
