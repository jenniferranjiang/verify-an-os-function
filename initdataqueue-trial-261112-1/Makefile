COQC ?= /home/xinra/.opam/pv-bench-8.20.1/bin/coqc
.PHONY: lib clean
lib:
	python3 checks/compile.py
clean:
	find lib -maxdepth 1 -type f \( -name '*.vo' -o -name '*.vos' -o -name '*.vok' -o -name '*.glob' -o -name '.*.aux' \) -delete
