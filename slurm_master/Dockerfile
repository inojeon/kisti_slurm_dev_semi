FROM inojeon/slurm_base_rocky8:21

# 실행 파일 Copy
COPY slurm_master/master-entrypoint.sh /usr/local/bin/master-entrypoint.sh

# END
RUN ["chmod", "+x", "/usr/local/bin/master-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/master-entrypoint.sh"]
# CMD ["/bin/bash"]
