PYTHON_VER      := 3.9.9
VENV_NAME       := venv399
ARCH            := $(shell uname -m)


virtualenv/create:
	$(eval ret := $(shell pyenv versions | grep $(PYTHON_VER)))
	@if [ -n "$(ret)" ]; then \
		echo '$(PYTHON_VER) exists'; \
	else \
		(pyenv install $(PYTHON_VER)); \
	fi
	$(eval ret := $(shell pyenv versions | grep $(VENV_NAME)))
	@if [ -n "$(ret)" ]; then \
		echo '$(VENV_NAME) exists'; \
	else \
		(pyenv virtualenv $(PYTHON_VER) $(VENV_NAME)); \
	fi
	pyenv local $(VENV_NAME)
	pyenv versions
	poetry env info

virtualenv/install:
	poetry install

virtualenv/destroy:
	pyenv local --unset
	pyenv virtualenv-delete -f $(VENV_NAME)
	pyenv versions

__check_arch_x64__:
	@[ "$(ARCH)" = "x86_64" ] || (echo "[ERROR] Parameter [ARCH] must be x86_64" 1>&2 && echo "(e.g) in zsh: \`$ arch -x86_64 zsh\` " 1>&2 && exit 1)

__check_arch_arm__:
	@[ "$(ARCH)" = "arm64" ] || (echo "[ERROR] Parameter [ARCH] must be arm64" 1>&2 && echo "(e.g) in zsh: \`$ arch -arm64e  zsh\` " 1>&2 && exit 1)