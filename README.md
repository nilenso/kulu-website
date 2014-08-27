# kulu-website

The webapp for the Kulu app.

## Set up

### AWS S3 CORS permissions

The JS in the app directly uploads files into S3. For this to work,
the CORS permissions need to be set up on the S3 bucket. Steps:

1. Visit the
   [S3 AWS Console](https://console.aws.amazon.com/s3/home?region=us-east-1#)
1. Select the bucket (see `application.yml` for the names).
1. Click **Properties** tab
1. Open up the CORS Configuration and change the HTTP methods and
headers XML nodes (retain  everything else):
```
<AllowedMethod>HEAD</AllowedMethod>
<AllowedMethod>GET</AllowedMethod>
<AllowedMethod>POST</AllowedMethod>

<AllowedHeader>*</AllowedHeader>
```

Remember to do this for both dev and prod buckets.
