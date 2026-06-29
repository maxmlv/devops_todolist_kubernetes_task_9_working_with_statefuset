# Working with StatefulSets

After running `bootstrap.sh`, use the steps below to confirm everything is working.

## 1. Run bootstrap

```bash
./bootstrap.sh
```

Confirm every resource in the output shows `created` (or `unchanged`/`configured` on a re-run), with no `error` lines.

## 2. MySQL infrastructure validation

Check the StatefulSet pod is `Running` and `1/1 Ready`:

```bash
kubectl get pods -n mysql
```

Check the PVC created by `volumeClaimTemplates` is `Bound`:

```bash
kubectl get pvc -n mysql
```

Check logs to confirm MySQL fully started and `init.sql` ran:

```bash
kubectl logs mysql-0 -n mysql
```

Look for a line like `ready for connections` near the end of the log, and confirm any database/user creation messages from `init.sql` appear without errors.

Exec into the pod and confirm MySQL responds:

```bash
kubectl exec -n mysql -it mysql-0 -- mysqladmin ping
```

Expected output: `mysqld is alive`.

Logs:

```
2026-06-29T15:34:45.575358Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2026-06-29T15:34:46.092095Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2026-06-29T15:34:46.674935Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
2026-06-29T15:34:46.674994Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
2026-06-29T15:34:46.680112Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
2026-06-29T15:34:46.721953Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
2026-06-29T15:34:46.722195Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.46'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

## 3. App validation via ClusterIP and NodePort

Check the app pod is `Running` and `1/1 Ready`:

```bash
kubectl get pods -n todoapp
```

Check services exist:

```bash
kubectl get svc -n todoapp
```

**NodePort** (external access — test from your host machine):

```bash
curl http://localhost:30007/api/health
```

Expected: a `200`-style healthy response body, confirming the app is reachable from outside the cluster through the NodePort.

## 4. Confirm the app can reach MySQL end-to-end

Check the app's logs for successful database connection (no connection errors on startup):

```bash
kubectl logs <app-pod-name> -n todoapp
```

Optionally, exercise an app endpoint that reads/writes data (e.g. create a todo item via the API or UI) and confirm it persists.

```
[29/Jun/2026 15:38:09] "POST /todolist/new/ HTTP/1.1" 302 0
[29/Jun/2026 15:38:09] "GET /todolist/1/ HTTP/1.1" 200 4326
[29/Jun/2026 15:38:09] "GET /static/lists/js/lists.js HTTP/1.1" 200 1778
[29/Jun/2026 15:38:10] "GET /api/ready HTTP/1.1" 200 12
[29/Jun/2026 15:38:11] "GET /api/todos/1/ HTTP/1.1" 200 151
[29/Jun/2026 15:38:11] "PUT /api/todos/1/ HTTP/1.1" 200 175
[29/Jun/2026 15:38:11] "GET /todolist/1/ HTTP/1.1" 200 4342
```