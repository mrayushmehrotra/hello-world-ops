 #!/bin/bash

echo "🚀 Setting up local Kubernetes deployment..."

# Check if minikube is installed
if ! command -v minikube &> /dev/null; then
    echo "❌ Minikube not found. Installing..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
fi

# Start minikube
echo "🔧 Starting minikube..."
minikube start

# Set docker environment to use minikube's docker daemon
echo "🐳 Configuring Docker environment..."
eval $(minikube docker-env)

# Build Docker image
echo "🏗️ Building Docker image..."
docker build -t hello-world-ops:latest .

# Apply Kubernetes manifests
echo "📦 Deploying to Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/hello-world-ops -n hello-world-ops --timeout=300s

# Show deployment status
echo "📊 Deployment status:"
kubectl get pods -n hello-world-ops
kubectl get svc -n hello-world-ops

# Get the service URL
echo "🌐 Service URL:"
minikube service hello-world-ops-service -n hello-world-ops --url

echo "✅ Deployment complete! Use 'minikube service hello-world-ops-service -n hello-world-ops' to open the app"
echo "🔍 To check logs: kubectl logs -f deployment/hello-world-ops -n hello-world-ops"
echo "🛑 To stop: minikube stop"