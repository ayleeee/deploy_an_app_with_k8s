# Kubernetes를 활용한 애플리케이션 배포 
Kubernetes를 활용하여 어플리케이션 배포 하는 법에 대해 논합니다.

### [1] docker 이미지 만들기

(1) 스냅샷 찍기 -> SpringApp-0.0.1-SNAPSHOT.jar
![image](https://github.com/user-attachments/assets/018e88fd-e084-4b4b-aa63-b654acae1dc0)
![image](https://github.com/user-attachments/assets/face382d-c305-42ed-b535-622e765bbe83)
> Apply 후 Run 실행.

![image](https://github.com/user-attachments/assets/24151abe-9b38-400a-a4f7-72d39d69eadc)
> SpringApp/build/libs 경로에 SNAPSHOT 존재. 해당 파일을 작업할 폴더로 이동.


(2) 스냅샷을 활용하여 docker image 만들기<br>
docker image는 Dockerfile을 통해 생성할 수 있음.
```dockerfile
# 베이스 이미지 설정
FROM openjdk:17-jdk-alpine

# 컨테이너 내부에서 작업할 디렉토리
WORKDIR /app

# 지정된 경로에서 JAR 파일을 컨테이너로 복사
COPY ./SpringApp-0.0.1-SNAPSHOT.jar /app/SpringApp.jar

# 애플리케이션이 실행될 포트 노출
EXPOSE 8999

# JAR 파일을 실행하기 위한 entrypoint
ENTRYPOINT ["java", "-jar", "/app/SpringApp.jar"]
```
(3) 확인 단계<br>
```docker build -t springapp:latest .``` 로 이미지 빌드 후,
```docker run -p 8999:8999 springapp:latest``` 정상 작동하는지 테스트

(4) docker hub에 업로드 <br>
```
docker tag springapp angielee123/springapp:1.0
docker push angielee123/springapp:1.0
```
![image (4)](https://github.com/user-attachments/assets/1c2f3862-6fcb-43a7-8006-73be7be0ba9f)

---

### [2] Kubernetes 사용해서 배포하기
test 목적이기에 minikube 사용
```
minikube start
kubectl create deployment springapp --image=angielee123/springapp:1.0 --replicas=3
kubectl expose deployment springapp --type=LoadBalancer --port=8999
service/springapp exposed
minikube tunnel 
```
tunnel 후 연결된 external ip:port 포트포워딩<br>
![image (5)](https://github.com/user-attachments/assets/8ae6b58d-e038-4541-b39b-6077e95dbfc7)

결과물<br>
![image (6)](https://github.com/user-attachments/assets/c139b8ee-862e-4750-932a-1ebc70e5d896)

