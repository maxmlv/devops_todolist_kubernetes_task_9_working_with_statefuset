# MySQL infrastructure
kubectl apply -f ./.infrastructure/mysql/namespace.yml
kubectl apply -f ./.infrastructure/mysql/secret.yml
kubectl apply -f ./.infrastructure/mysql/configMap.yml
kubectl apply -f ./.infrastructure/mysql/services.yml
kubectl apply -f ./.infrastructure/mysql/statefulSet.yml

# Application infrastructure
kubectl apply -f ./.infrastructure/app/namespace.yml

kubectl apply -f ./.infrastructure/app/pv.yml
kubectl apply -f ./.infrastructure/app/pvc.yml
kubectl apply -f ./.infrastructure/app/configMap.yml
kubectl apply -f ./.infrastructure/app/secret.yml

kubectl apply -f ./.infrastructure/app/deployment.yml

kubectl apply -f ./.infrastructure/app/clusterIp.yml
kubectl apply -f ./.infrastructure/app/nodeport.yml