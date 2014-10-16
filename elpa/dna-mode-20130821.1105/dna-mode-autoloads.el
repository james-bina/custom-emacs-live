;;; dna-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (dna-isearch-forward dna-reverse-complement-region
;;;;;;  dna-add-hooks dna-mode) "dna-mode" "dna-mode.el" (21454 6849
;;;;;;  0 0))
;;; Generated autoloads from dna-mode.el

(autoload 'dna-mode "dna-mode" "\
Major mode for editing DNA sequences.

This mode also customizes isearch to search over line
breaks.  Use \\[universal-argument] number as a prefix to
`dna-forward-base' to move that many bases.  This skips line
breaks and spaces.

`dna-color-bases-region' disables `font-lock-mode'
automaticly as they cant work together.
\\[dna-color-bases-region] turns `font-lock-mode' back on.

\\{dna-mode-map}

\(fn)" t nil)

(autoload 'dna-add-hooks "dna-mode" "\
Add a default set of dna-hooks.
These hooks will activate `dna-mode' when visiting a file
which has a dna-like name (.fasta or .gb) or whose contents
looks like dna.  It will also turn enable fontification for `dna-mode'.

\(fn)" nil nil)

(autoload 'dna-reverse-complement-region "dna-mode" "\
Reverse complement a region of dna from R-START to R-END.
Works by deleting the region and inserting bases reversed
and complemented, while entering non-bases in the order
found.

\(fn R-START R-END)" t nil)

(autoload 'dna-isearch-forward "dna-mode" "\
Isearch forward on dna sequence.
Enable the `dna-mode' search string mangling advice and start the search.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("dna-mode-pkg.el" "dna-primer.el") (21454
;;;;;;  6849 105253 0))

;;;***

(provide 'dna-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dna-mode-autoloads.el ends here
