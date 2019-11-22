    
FROM docker.elastic.co/elasticsearch/elasticsearch:7.1.1
ENV ELASTICSEARCH_VERSION 7.1.1
COPY hunspell /usr/share/elasticsearch/config/hunspell/
COPY stopwords /usr/share/elasticsearch/config/stopwords/
USER root
RUN chown -R elasticsearch:elasticsearch config/*
USER elasticsearch
RUN elasticsearch-plugin install analysis-icu --batch \
  && elasticsearch-plugin install analysis-smartcn --batch \
  && elasticsearch-plugin install ingest-attachment --batch \
  && elasticsearch-plugin install https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v$ELASTICSEARCH_VERSION/elasticsearch-analysis-lemmagen-$ELASTICSEARCH_VERSION-plugin.zip --batch \
  && curl -L -O https://github.com/vhyza/lemmagen-lexicons/archive/v1.0.tar.gz \
  && tar zxf v1.0.tar.gz \
  && mkdir config/lemmagen && mv ./lemmagen-lexicons-1.0/free/lexicons/* config/lemmagen/ \
  && mv ./lemmagen-lexicons-1.0/non-free/lexicons/* config/lemmagen/ \
  && rm v1.0.tar.gz && rm -R ./lemmagen-lexicons-1.0