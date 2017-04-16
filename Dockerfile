FROM nvidia/cuda:8.0-cudnn5-devel

RUN apt-get update && apt-get install -y \
				git \
				sudo \
				vim \
				wget

ADD /sudoers /etc/sudoers

RUN chmod 440 /etc/sudoers && \
	useradd -ms /bin/bash datasci && \
	usermod -aG sudo datasci

USER datasci
WORKDIR /home/datasci

RUN git clone https://github.com/torch/distro.git ~/torch --recursive && \
		cd ~/torch && bash install-deps && \
		yes | ./install.sh

ENV PATH=/home/datasci/torch/install/bin:$PATH
ENV LUA_PATH='/home/datasci/.luarocks/share/lua/5.1/?.lua;/home/datasci/.luarocks/share/lua/5.1/?/init.lua;/home/datasci/torch/install/share/lua/5.1/?.lua;/home/datasci/torch/install/share/lua/5.1/?/init.lua;./?.lua;/home/datasci/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' \
	LUA_CPATH='/home/datasci/.luarocks/lib/lua/5.1/?.so;/home/datasci/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' \
	PATH=/home/datasci/torch/install/bin:$PATH \
	LD_LIBRARY_PATH=/home/datasci/torch/install/lib:$LD_LIBRARY_PATH \
	DYLD_LIBRARY_PATH=/home/datasci/torch/install/lib:$DYLD_LIBRARY_PATH
ENV LUA_CPATH='/home/datasci/torch/install/lib/?.so;'$LUA_CPATH