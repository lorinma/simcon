from lorinma/dockeride:0.1
MAINTAINER lorinma <malingreal [at] gmail {dot} com>
RUN apt-get install -y --force-yes --no-install-recommends python-openssl libssl-dev libffi-dev
RUN pip install gspread numpy pandas oauth2client cryptography
RUN pip install -U https://github.com/RandomOrg/JSON-RPC-Python/zipball/master
RUN pip install -U https://github.com/google/google-visualization-python/zipball/master
WORKDIR /usr/game
