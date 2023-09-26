# slurm 이미지

컨테이너 실행을 위해 사용하는 이미지는 3개

- mariadb:10.10
- inojeon/slurm_master_rocky8:21
- inojeon/slurm_worker_rocky8:21

docker hub에 올려두었으며, 각 이미지의 Dockerfile은 slurm_master, slurm_worker에 있음

## docker compose로 실헹

### slurm 및 qe_demo 실행 test

실행

```
docker-compose up -d
```

계산노드 접속

```
docker-compose exec slurmd-0 /bin/bash
```

작업 폴더 생성 및 sbatch.ex.sh 실행

```
[root@slurmd-0 1]# mkdir /EDISON2/home/user/jobs/1
[root@slurmd-0 1]# cd /EDISON2/home/user/jobs/1
[root@slurmd-0 1]# sbatch /EDISON2/solvers/semi/qe_demo/1.0.0/sbatch.ex.sh
Submitted batch job 2
[root@slurmd-0 1]# squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 2     basic    test1     root  R       0:01      1 slurmd-0
[root@slurmd-0 1]# ls
QESim.save  QESim.xml  bands.out      json_kpath.json   simulation_2.txt  std.err
QESim.wfc   Si.UPF     bands.out.gnu  simulation_1.txt  simulation_3.txt  std.out
```

### Solver 파일 관리 정리

/EDISON2/solvers/{field}/{sovlerName}/{version} 형태로 폴더 관리

setting.yaml 파일은 꼭 있어야함
-> solver 등록 관리 시스템에서 해당 yaml의 정보를 DB에 관리해야함

```
---
name: qe_demo
version: 1.0.0
location:
shell: python3
mainExe: script_modeling.py
inputs:
  - option: "--inp"
    exec: toml
    sampleInputPath: inputs/input.toml
  - option: "--xsf"
    exec: xsf
    sampleInputPath: inputs/input.xsf
runScript: |
  export PROGRAM_HOME={{PROGRAM_HOME}}

  python3 {{PROGRAM_HOME}}/script_modeling.py {{inputArgs}}

  pw.x < simulation_1.txt
  pw.x < simulation_2.txt
  bands.x < simulation_3.txt
slurm:
  runType: single
```

## workbench 실행을 위해 구현해야하는 내용

- 사용자 작업 요청
- 직업 폴더 생성
- setting.yaml 과 웹에서 사용자가 생성한 입력파일 경로를 이용하여 sbatch.ex.sh 형태의 파일을 만들고 sbatch 실행

## k8s에서 실행

컨테이너 생성

```
cd k8s
k apply -f namespace.yaml
k apply -f pvc.yaml
k apply -f svc.yaml
k apply -f deploy.yaml
```

컨테이너 접속

```
k exec -it -n slurm slurmd-1 /bin/bash
```

볼륨 마운트가 되지 않아 작업 폴더 생성 및 solver 실행 파일 다운로드 후 sbatch 실행

```
mkdir -p /EDISON2/solvers/semi/qe_demo
cd /EDISON2/solvers/semi/qe_demo
git clone https://github.com/inojeon/qe_demo.git
mv qe_demo 1.0.0

mkdir -p /EDISON2/home/user/jobs/1
cd /EDISON2/home/user/jobs/1
sbatch /EDISON2/solvers/semi/qe_demo/1.0.0/sbatch.ex.sh
```

## 시뮬레이션 실행 폴더 위치 정의

- /EDISON2/home/{userId} : 사용자 홈
  - /{projectName} : 사용자 프로젝트 홈
    - /repository : 입력 파일
    - /jobs : 작업 폴더
      - /{jobUUID} : 작업 실행 폴더
- /EDISON2/solvers/{filed}/{sovlerName}/{version} : 솔버 파일 위치
- /EDISON2/singularity/{filed}/{singularityName}/{version}/ : 싱귤러리티 파일 위치
