## 시뮬레이션 실행 폴더 위치 정의

- /EDISON2/home/{userId} : 사용자 홈
  - /{projectName} : 사용자 프로젝트 홈
    - /repository : 입력 파일
    - /jobs : 작업 폴더
      - /{jobUUID} : 작업 실행 폴더
- /EDISON2/solvers/{filed}/{sovlerName}/{version} : 솔버 파일 위치
- /EDISON2/singularity/{filed}/{singularityName}/{version}/ : 싱귤러리티 파일 위치
-

### Solver 파일 관리 정리

/EDISON2/solvers/{sovlerName}/{version} 형태로 폴더 관리

setting.yaml 파일은 꼭 있어야함

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
