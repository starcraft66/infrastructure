# Photoprism MySQL Hack
---

The MySQL operator I deployed is of alpha quality and not very good. I only noticed this after deploying it. I plan to move to a more mature one in the future. The problem here is that it doesn't allow me to specify a pvc template for the mysql datadir so the hack is to delete the one the operator creates and apply this pvc by hand.

I'll fix this eventually™
