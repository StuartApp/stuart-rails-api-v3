
```
docker build -t rails-api . && docker run --rm -p 3000:3000 rails-api
```

Endpoints:
```
GET http://localhost:3000/v3/health
POST http://localhost:3000/v3/orders
POST http://localhost:3000/v3/orders/http-delay
```

Environment:

```
PORT=3000
HTTP_DELAY_IN_SECONDS=2
```
