y 4 — Git Complete 🔥 (Hinglish Notes)

---

## Git Kya Hai — Pehle Solidly Samajh

Tu codebase pe kaam kar raha hai. Naya feature banana hai — but purana code toot nahi chahiye.

```
Main codebase (main branch)
        │
        ├──── naya feature add karna hai
        │
        └──── directly main mein karo? DANGEROUS!
               Kuch galat hua → purana bhi toot gaya! 😱
```

**Isliye branches hoti hain:**
- `main branch` → stable, production wala code
- `feature branch` → teri apni copy, apne se khelo — main safe rahega

> **Analogy:** Jaise exam ke notes ki photocopy le lo — original safe!

---

## 1. git checkout -b — Branch Banana + Switch Karna

### Naya branch banao:
```bash
git checkout -b feature/git-practice
```
Output: `Switched to a new branch 'feature/git-practice'`

### Kya hua internally:
```
main branch          →  purana stable code
      │
      └── feature/git-practice  ←  TU ABHI YAHAN HAI
               (main ki exact copy — abhi same hai)
```

> **Analogy:** Novel ki photocopy li — dono identical hain abhi!

### Saari branches dekho:
```bash
git branch
```
```
* feature/git-practice   ← * = TU ABHI YAHAN HAI
  main
```

---

## 2. git merge — Branches Ko Join Karna

### Pehle feature pe kuch kaam karo:
```bash
echo "# Git Day 4 Practice" > notes/git_test.md
git add notes/git_test.md
git commit -m "feat: add git practice notes"
```

### Main pe jao aur dekho — magic!
```bash
git checkout main
ls notes/
# git_test.md GAYAB! ← branches = parallel universes!
```

### Feature ka kaam main mein lao:
```bash
git merge feature/git-practice
```
Output: `Fast-forward`

### Fast-forward kya hota hai?
```
PEHLE:
main     →  A
              |
feature  →  B  (1 commit aage)

BAAD MEIN (Fast-forward):
main     →  B  ← seedha yahan aa gaya!
feature  →  B  (same!)
```
> Jaise bookmark aage badhaaya — koi naya commit nahi bana! Ekdum clean! ✅

---

## 3. git rebase — Clean History Banana

### Merge vs Rebase fark:

```
Merge karo toh:
A → B → C → D → M  (M = merge commit — messy!)
                ↗
           E → F

Rebase karo toh:
A → B → C → D → E' → F'  (clean linear history!)
```

> **Rebase = teri commits ko main ke upar rakho** — jaise tune pehle se wahan se hi shuru kiya tha!

### Diverged scenario banao (simulate karo):
```bash
# Feature pe commit karo
git checkout -b feature/rebase-test
echo "rebase practice" > notes/rebase_test.md
git add notes/rebase_test.md
git commit -m "feat: rebase test file"

# Main pe bhi commit karo (teammate simulate)
git checkout main
echo "main branch update" > notes/main_update.md
git add notes/main_update.md
git commit -m "feat: main branch new commit"
```

### Git log se divergence dekho:
```bash
git log --oneline --graph --all
```
```
* 5870cdc (HEAD -> main) feat: main branch new commit
| * 34bcdd0 (feature/rebase-test) feat: rebase test file
|/
* c8ae451  ← yahan se dono alag ho gayi!
```

### Ab rebase karo:
```bash
git checkout feature/rebase-test
git rebase main
```
```
BAAD MEIN:
main    → 5870cdc
               |
feature → d567e30  ← UPAR AA GAYA! (hash badla = commit recreate hua)
```

> **Note:** Commit hash badal jaata hai rebase ke baad — isliye `E'` (prime) bolte hain!

---

## 4. git stash — Kaam Temporarily Locker Mein Rakho

### Kab use karo?
Jab kuch unstaged changes hain aur rebase/checkout karna ho.

```bash
git stash        # locker mein rakho
git rebase main  # ab kaam karo
git stash pop    # locker se wapas nikalo
```

### Stash ke commands:
| Command | Kya karta hai |
|---|---|
| `git stash` | Changes temporarily save karo |
| `git stash pop` | Changes wapas lo + stash delete karo |
| `git stash list` | Locker mein kya kya hai dekho |

> **Analogy:** Exam mein tha → bag mein phone rakha (stash). Exam khatam → bag se phone nikala (stash pop). Phone safe tha, exam bhi diya! ✅

---

## 5. git reset — Commit Undo Karna (DANGEROUS)

### Test commit banao:
```bash
echo "yeh galti se commit ho gaya" > notes/mistake.md
git add notes/mistake.md
git commit -m "oops: wrong commit"
```

### Reset karo — last commit undo:
```bash
git reset HEAD~1
```

### Kya hua:
```
PEHLE:                    BAAD MEIN:
commit → mistake.md       commit GAYAB ✅
                          file  BACHI  ✅
```

> `HEAD~1` = HEAD se 1 commit peeche jao

### Reset ke types:
| Command | Commit | Staging | File |
|---|---|---|---|
| `git reset HEAD~1` (default --mixed) | Gayab | Gayab | Bachi |
| `git reset --soft HEAD~1` | Gayab | Bachi | Bachi |
| `git reset --hard HEAD~1` | Gayab | Gayab | **GAYAB** ⚠️ |

---

## 6. git revert — Safe Undo (PRODUCTION WALA)

```bash
git revert HEAD
# Vi editor khulega → :wq karke save karo
```

### Log dekho — fark samajhna:
```
b331585  Revert "oops: wrong commit"   ← NAYA commit bana!
db3269a  oops: wrong commit            ← PURANA commit ABHI BHI HAI!
5870cdc  feat: main branch new commit
```

### Reset vs Revert — Final Fark:
```
git reset  →  history se commit DELETE karo
               Analogy: diary ka page faad do

git revert →  naya commit banao jo purana undo kare
               Analogy: diary mein likho "galti hui"
               SAFE! Audit trail bana rehta hai ✅
```

> **Rule:** Production mein hamesha `git revert` use karo!

---

## 7. git log --graph — History Visualize Karna

```bash
git log --oneline --graph --all
```

| Flag | Kya karta hai |
|---|---|
| `--oneline` | Har commit ek line mein |
| `--graph` | Tree/branch structure dikhao |
| `--all` | Saari branches dikhao |

### Sample output:
```
* b331585 (HEAD -> main) Revert "oops: wrong commit"
* db3269a oops: wrong commit
* 5870cdc feat: main branch new commit
* c8ae451 feat: add git practice notes
* 7512186 (origin/main) docs: add day 3 notes
```

---

## 8. Branch Cleanup

```bash
git branch -d feature/git-practice   # safe delete (sirf merged branch)
git branch -D feature/rebase-test    # force delete (merge na hua ho tab bhi)
```

> `-d` = safe guard hai — agar branch merge nahi hui toh Git rokega!  
> `-D` = "mujhe pata hai, force karo!"

---

## Quick Reference — Aaj Ke Saare Commands

| Command | Kaam |
|---|---|
| `git checkout -b <name>` | Naya branch banao + switch karo |
| `git branch` | Saari branches dekho |
| `git merge <branch>` | Branch ka kaam main mein lao |
| `git rebase main` | Commits ko main ke upar rakho |
| `git stash` | Changes temporarily save karo |
| `git stash pop` | Stashed changes wapas lo |
| `git reset HEAD~1` | Last commit undo (file bachi) |
| `git revert HEAD` | Safe undo — naya commit banta hai |
| `git branch -d <name>` | Branch delete (safe) |
| `git branch -D <name>` | Branch force delete |
| `git log --oneline --graph --all` | Tree mein history dekho |

---

## Mental Model — Sab Ek Saath

```
Branches    = Parallel universes (alag realities)
Merge       = Universes ko join karo
Rebase      = Apni timeline ko dusre ke aage lagao
Stash       = Temporary locker
Reset       = History faad do (dangerous!)
Revert      = History pe naya page likho (safe!)
```

**Day 4 — Done! 🔥**
