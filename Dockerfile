from lorinma/dockeride
MAINTAINER lorinma <malingreal [at] gmail {dot} com>
RUN apt-get install -y  --fix-missing --force-yes --no-install-recommends python-openssl libssl-dev libffi-dev
RUN pip install gspread numpy pandas oauth2client cryptography
RUN pip install -U https://github.com/RandomOrg/JSON-RPC-Python/zipball/master
RUN pip install -U https://github.com/google/google-visualization-python/zipball/master
RUN git clone https://github.com/lorinma/simcon.git /usr/local/src
