# kulu-website

The webapp for the Kulu app.

## Set up

+ Install `ruby` with rbenv/rvm ([version](.ruby-version)).
+ Find out corresponding `bundler` version with `cat Gemfile.lock | grep -A 1 "BUNDLED WITH"`
and install with `gem install bundler -v <bundler-version>`. (This is needed since newer `bundler` requires Ruby version >= 2.3.0.)
+ `bundle install` to install the required gems.
(If `nokogiri` installation fails due to missing `libiconv` headers you will need to install extra headers with
`open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg`. This is because Xcode 10 on MacOS Mojave
and above moves the system headers out of `/usr/include` causing a build failure for `nokogiri`.)
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
