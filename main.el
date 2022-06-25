(defcustom cc-mode-compiler "g++"
  "The compiler used for compiling the source file"
  :type 'string
  :local t)

(defcustom cc-mode-flags "-std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion"
  "A space-separated string of all the compiler flags used during compilation"
  :type 'string
  :local t)

(defcustom cc-mode-keymap-prefix "C-c"
  "Prefix key for all cc-mode keybindings"
  :type 'string
  :local t)

(defun file-or-curr (FILE)
  (if (FILE)
      FILE
    (buffer-file-name)))

(defun cc-mode--key (KEY)
  (kbd (concat cc-mode-keymap-prefix " " KEY)))

(defun cc-compile ()
  "Compiles the provided source file. If no filename is provided, then it compiles the current buffer."
  (interactive)

  (shell-command (concat cc-mode-compiler " " cc-mode-flags " " (buffer-file-name))))

(defun cc-open-custom-io-buffer ()
  "Opens an input and an output buffer on the right for the current source file"
  (interactive)
  (make-variable-buffer-local
   (defvar cc-input-buffer "cc-input-buffer"
     "Name for the input buffer"))
  (make-variable-buffer-local
   (defvar cc-output-buffer "cc-output-buffer"
     "Name for the output buffer"))
  (split-window-horizontally)
  (switch-to-buffer-other-window (get-buffer-create cc-input-buffer))
  (shrink-window-horizontally 20)
  (split-window-vertically)
  (switch-to-buffer-other-window (get-buffer-create cc-output-buffer))
  (setq mode-line-format nil)
  (other-window 2))

(defun cc-test-custom-input ()
  "Test the custom input specified in the input buffer"
  (interactive)
  (set-mark (point-min))
  (goto-char (point-max))
  (shell-command-on-region (region-beginning) (region-end) "./a.out"
			   (get-buffer-create cc-output-buffer))
  (setq deactivate-mark t))

(define-minor-mode cc-mode
  "Toggles buffer-local cc-mode"
  :init-value nil ; initial value
  :global t
  :lighter " cc-mode"
  :keymap
  (list (cons (cc-mode--key "c") 'cc-compile)
        (cons (cc-mode--key "o") 'cc-open-custom-io-buffer)
	(cons (cc-mode--key "t") 'cc-test-custom-input))
  (if cc-mode
      (message "cc-mode activated")
    (message "cc-mode deactivated")))
