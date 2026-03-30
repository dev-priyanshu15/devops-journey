# Day 4 — Git Complete 🔥 (English Notes)

---

## What is Git — Understand Clearly

You are working on a codebase. You want to add a new feature — but the existing code should not break.

```
Main codebase (main branch)
        │
        ├──── want to add a new feature
        │
        └──── do it directly in main? DANGEROUS!
               Something goes wrong → old code breaks too! 😱
```

**That's why branches exist:**
- `main branch` → stable, production code
- `feature branch` → your own copy, experiment freely — main stays safe

> **Analogy:** Like taking a photocopy of exam notes — the original stays safe!

---

## 1. git checkout -b — Create Branch + Switch

### Create a new branch:
```bash
git checkout -b feature/git-practice
```
Output: `Switched to a new branch 'feature/git-practice'`

### What happened internally:
```
main branch          →  old stable code
      │
      └── feature/git-practice  ←  YOU ARE HERE
               (exact copy of main — identical right now)
```

> **Analogy:** Took a photocopy of the novel — both are identical right now!

### View all branches:
```bash
git branch
```
```
* feature/git-practice   ← * = YOU ARE HERE
  main
```

---

## 2. git merge — Joining Branches

### Do some work on feature branch first:
```bash
echo "# Git Day 4 Practice" > notes/git_test.md
git add notes/git_test.md
git commit -m "feat: add git practice notes"
```

### Go to main and check — magic!
```bash
git checkout main
ls notes/
# git_test.md is GONE! ← branches = parallel universes!
```

### Bring feature work into main:
```bash
git merge feature/git-practice
```
Output: `Fast-forward`

### What is Fast-forward?
```
BEFORE:
main     →  A
              |
feature  →  B  (1 commit ahead)

AFTER (Fast-forward):
main     →  B  ← pointer just moved forward!
feature  →  B  (same!)
```
> Like moving a bookmark forward — no new commit created! Clean! ✅

---

## 3. git rebase — Clean History

### Merge vs Rebase difference:

```
With Merge:
A → B → C → D → M  (M = merge commit — messy!)
                ↗
           E → F

With Rebase:
A → B → C → D → E' → F'  (clean linear history!)
```

> **Rebase = place your commits on top of main** — as if you started from there!

### Create a diverged scenario (simulate):
```bash
# Commit on feature branch
git checkout -b feature/rebase-test
echo "rebase practice" > notes/rebase_test.md
git add notes/rebase_test.md
git commit -m "feat: rebase test file"

# Also commit on main (simulate teammate)
git checkout main
echo "main branch update" > notes/main_update.md
git add notes/main_update.md
git commit -m "feat: main branch new commit"
```

### See divergence in git log:
```bash
git log --oneline --graph --all
```
```
* 5870cdc (HEAD -> main) feat: main branch new commit
| * 34bcdd0 (feature/rebase-test) feat: rebase test file
|/
* c8ae451  ← both branches split from here!
```

### Now rebase:
```bash
git checkout feature/rebase-test
git rebase main
```
```
AFTER:
main    → 5870cdc
               |
feature → d567e30  ← MOVED ON TOP! (hash changed = commit recreated)
```

> **Note:** Commit hash changes after rebase — that's why we say `E'` (E prime)!

---

## 4. git stash — Temporary Storage

### When to use?
When you have unstaged changes and need to rebase/checkout.

```bash
git stash        # save to temporary storage
git rebase main  # do your work
git stash pop    # bring changes back
```

### Stash commands:
| Command | What it does |
|---|---|
| `git stash` | Temporarily save changes |
| `git stash pop` | Restore changes + delete stash |
| `git stash list` | See what's in stash |

> **Analogy:** In exam → kept phone in bag (stash). Exam done → took phone back (stash pop). Phone was safe, exam was given too! ✅

---

## 5. git reset — Undo Commit (DANGEROUS)

### Create a test commit:
```bash
echo "this was committed by mistake" > notes/mistake.md
git add notes/mistake.md
git commit -m "oops: wrong commit"
```

### Reset — undo last commit:
```bash
git reset HEAD~1
```

### What happened:
```
BEFORE:                   AFTER:
commit → mistake.md       commit GONE ✅
                          file  SAFE  ✅
```

> `HEAD~1` = go 1 commit behind HEAD

### Types of reset:
| Command | Commit | Staging | File |
|---|---|---|---|
| `git reset HEAD~1` (default --mixed) | Gone | Gone | Safe |
| `git reset --soft HEAD~1` | Gone | Safe | Safe |
| `git reset --hard HEAD~1` | Gone | Gone | **GONE** ⚠️ |

---

## 6. git revert — Safe Undo (PRODUCTION)

```bash
git revert HEAD
# Vi editor opens → save with :wq
```

### Check log — understand the difference:
```
b331585  Revert "oops: wrong commit"   ← NEW commit created!
db3269a  oops: wrong commit            ← OLD commit STILL EXISTS!
5870cdc  feat: main branch new commit
```

### Reset vs Revert — Final Difference:
```
git reset  →  DELETE commit from history
               Analogy: Tear out the diary page

git revert →  Create new commit that undoes old one
               Analogy: Write "made a mistake" in diary
               SAFE! Audit trail preserved ✅
```

> **Rule:** Always use `git revert` in production!

---

## 7. git log --graph — Visualize History

```bash
git log --oneline --graph --all
```

| Flag | What it does |
|---|---|
| `--oneline` | Each commit in one line |
| `--graph` | Show tree/branch structure |
| `--all` | Show all branches |

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
git branch -d feature/git-practice   # safe delete (only if merged)
git branch -D feature/rebase-test    # force delete (even if not merged)
```

> `-d` = safe guard — Git will stop you if branch is not merged!
> `-D` = "I know what I'm doing, force it!"

---

## Quick Reference — All Commands

| Command | Purpose |
|---|---|
| `git checkout -b <name>` | Create new branch + switch |
| `git branch` | View all branches |
| `git merge <branch>` | Bring branch work into main |
| `git rebase main` | Place commits on top of main |
| `git stash` | Temporarily save changes |
| `git stash pop` | Restore stashed changes |
| `git reset HEAD~1` | Undo last commit (file stays) |
| `git revert HEAD` | Safe undo — creates new commit |
| `git branch -d <name>` | Delete branch (safe) |
| `git branch -D <name>` | Force delete branch |
| `git log --oneline --graph --all` | View history as tree |

---

## Mental Model — Everything Together

```
Branches    = Parallel universes (separate realities)
Merge       = Join the universes
Rebase      = Place your timeline ahead of theirs
Stash       = Temporary locker
Reset       = Tear out history (dangerous!)
Revert      = Write a new page on history (safe!)
```

**Day 4 — Done! 🔥**
