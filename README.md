# kulu-website

The webapp for the Kulu app.

## Set up

+ Install `ruby` with rbenv/rvm, if you don't have it already
  ([version](.ruby-version)).
+ `gem install bundler` if you have a new ruby install from the above step.
+ `bundle install` to install the required gems.
+ `npm install` to install all the js requisites.


###### Minor note

Since this a rails app, it requires you to setup a DB for the rails server to start up (even though we don't actually use a database for this frontend).
Please copy over the `database.yml.sample` file to `database.yml` and make the required changes about your username and database and run the following command: 
+ run `bin/rake db:create db:migrate`
+ Copy over `application.yml.sample` to `application.yml`
+ Make the necessary config changes, especially the `KULU_BACKEND_SERVICE_URL`

Once that's done, start the server with:

+ run `bin/rails server` to the start the server


Once started visit [http://localhost:3000](http://localhost:3000)

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

## Extractor API

The extractor interface, which is used to extract/transcribe expenses for all organizations is separated out from the rest of the code.
As we may not need a different end-point for this to work as it could just be regular user-role later on. For easy removal of this, it's split into these files:

* `models/kulu_service/extractor_api.rb`
* `controllers/extractor_controller.rb`
* `views/extractor/`
