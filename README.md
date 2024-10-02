# Kubernetes를 활용한 애플리케이션 배포

이 문서는 Spring Boot 애플리케이션의 Docker 이미지 생성부터 Docker Hub 업로드 및 Minikube를 활용한 Kubernetes 클러스터 배포까지의 과정을 다룬다.


## 1단계: Docker 이미지 생성

### 스냅샷 생성
SpringBoot 애플리케이션의 스냅샷을 생성. `SpringApp-0.0.1-SNAPSHOT.jar` 파일이 `[App이름]/build/libs` 경로에 생성되어야 함.

<img src="https://github.com/user-attachments/assets/018e88fd-e084-4b4b-aa63-b654acae1dc0" alt="snapshot" />

![372706631-face382d-c305-42ed-b535-622e765bbe83](https://github.com/user-attachments/assets/b0c91965-7a81-4fcf-a4f7-0c4196cfc495)


이렇게 생성된 파일을 작업 폴더로 이동.

### Docker 이미지 빌드
위의 스냅샷을 베이스로 Dockerfile 작성.

```dockerfile
# 베이스 이미지 설정
FROM openjdk:17-jdk-alpine

# 컨테이너 내 작업 디렉토리 설정
WORKDIR /app

# JAR 파일을 컨테이너로 복사
COPY ./SpringApp-0.0.1-SNAPSHOT.jar /app/SpringApp.jar

# 애플리케이션 포트 노출
EXPOSE 8999

# 애플리케이션 실행을 위한 엔트리포인트 설정
ENTRYPOINT ["java", "-jar", "/app/SpringApp.jar"]
```

### Docker 이미지 테스트
Dockerfile이 있는 폴더에서 Dokcer 이미지 빌드.

```bash
docker build -t springapp:latest .
```

실행 명령어로 작동 여부 확인.

```bash
docker run -p 8999:8999 springapp:latest
```

### Docker Hub에 업로드
로컬에서 테스트한 Docker 이미지를 Kubernetes에서 배포할 수 있도록 Docker Hub에 업로드.

1. 이미지 태그 설정:
   ```bash
   docker tag springapp angielee123/springapp:1.0
   ```

2. Docker Hub에 푸시:
   ```bash
   docker push angielee123/springapp:1.0
   ```

![docker-hub-upload](https://github.com/user-attachments/assets/1c2f3862-6fcb-43a7-8006-73be7be0ba9f)

---

## 2단계: Kubernetes로 애플리케이션 배포

### Minikube 설정

```bash
minikube start
```

### Deployment 생성

```bash
kubectl create deployment springapp --image=angielee123/springapp:1.0 --replicas=3
```

### 애플리케이션 노출
클러스터 외부에서 접근을 허용하기 위해 `LoadBalancer` 서비스로 노출시키기.

```bash
kubectl expose deployment springapp --type=LoadBalancer --port=8999
```

### 애플리케이션 접근
Minikube 터널을 생성하여 외부 IP 생성.

```bash
minikube tunnel
```

이후, 생성된 외부 IP와 포트를 포트포워딩하여 접근 가능하게 만들기.
![image](https://github.com/user-attachments/assets/8eb66488-215a-42b5-95b4-bce90ed1a0ce)
![image](https://github.com/user-attachments/assets/b3c0fb89-50a1-44db-b81a-6a3ffddffd5d)


