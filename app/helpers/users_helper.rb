module UsersHelper


  def working_hours(a,b)
    # 分単位の計算
    # どう見てももっとスマートなやり方が絶対ある・・・
    timein = Time.mktime(a.year, a.month, a.day, a.hour, a.min, 0, 0)
    timeout = Time.mktime(b.year, b.month, b.day, b.hour, b.min, 0, 0)
    # 秒数を求める
    (((timeout - timein) / 60) / 60).truncate(2)
  end
  
  def times(x,y)
    c = Time.mktime(x.year, x.month, x.day, x.hour, x.min, 0, 0)
    d = Time.mktime(y.year, y.month, y.day, y.hour, y.min, 0, 0)
    d - c
  end  
  
  
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end