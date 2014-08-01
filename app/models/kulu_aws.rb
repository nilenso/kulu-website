class KuluAWS
  def s3_bucket
    @s3_bucket ||= AWS::S3.new.buckets[ENV['KULU_S3_TMP_BUCKET']]
  end

  def presigned_post
    s3_bucket.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}",
                             success_action_status: 201,
                             acl: :public_read)
  end
end
