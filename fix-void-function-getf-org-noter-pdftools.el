;; Fix org-noter-pdftools error: void function getf
(with-eval-after-load 'org-pdftools
  (require 'cl-lib)

  (defun my/org-pdftools-open-pdftools (link)
    "Fixed version of `org-pdftools-open-pdftools` using cl-getf."
    (let ((pdf-link (org-pdftools-parse-link link)))
      (cond
       ((cl-getf pdf-link :path)
        (let* ((path (cl-getf pdf-link :path))
               (page (cl-getf pdf-link :page))
               (height (cl-getf pdf-link :height))
               (annot-id (cl-getf pdf-link :annot-id))
               (search-string (cl-getf pdf-link :search-string)))
          (when (and path (not (string-empty-p path)))
            (if (and page (not (string-empty-p page)))
                (progn
                  (org-open-file path 1)
                  (pdf-view-goto-page (string-to-number page)))
              (org-open-file path 1)))
          (when (and height (not (string-empty-p height)))
            (image-set-window-vscroll (string-to-number height)))
          (when (and annot-id (not (string-empty-p annot-id)))
            (pdf-annot-show-annotation annot-id t))
          (when (and search-string (not (string-empty-p search-string)))
            (isearch-mode t)
            (isearch-yank-string search-string))))
       ((cl-getf pdf-link :pathlist)
        (pdf-occur-search (cl-getf pdf-link :pathlist)
                          (cl-getf pdf-link :occur-search-string)))
       (t (message "Invalid pdf link.")))))

  ;; Override the original function
  (advice-add 'org-pdftools-open-pdftools :override #'my/org-pdftools-open-pdftools))
