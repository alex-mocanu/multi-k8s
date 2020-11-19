# Build and push Docker images
docker build -t alexmocanu/multi-client:latest -t alexmocanu/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t alexmocanu/multi-server:latest -t alexmocanu/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t alexmocanu/multi-worker:latest -t alexmocanu/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push alexmocanu/multi-client:latest
docker push alexmocanu/multi-server:latest
docker push alexmocanu/multi-worker:latest

docker push alexmocanu/multi-client:$SHA
docker push alexmocanu/multi-server:$SHA
docker push alexmocanu/multi-worker:$SHA

# Apply Kubernetes config files
kuberctl apply -f k8s

# Set Docker image for Kubernetes cluster
kubectl set image deployments/server-deployment server=alexmocanu/multi-server:$SHA
kubectl set image deployments/client-deployment client=alexmocanu/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=alexmocanu/multi-worker:$SHA