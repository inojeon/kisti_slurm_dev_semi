FROM inojeon/slurm_base_rocky8:21

RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh\
  && bash nodesource_setup.sh \
  && dnf install nodejs -y \
  && npm i -g pnpm

# 실행 스크립트 파일 Copy
COPY slurm_worker/api-entrypoint.sh /usr/local/bin/api-entrypoint.sh

# END
RUN ["chmod", "+x", "/usr/local/bin/api-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/api-entrypoint.sh"]