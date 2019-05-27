说明 拿到项目 请看文字

	pod install


##封装的文件有两个(主要用于m3u8的播放和下载)
##1 ijk播放器
KPIjkVideoView  **(对于ijkplayer的二次封装 本demo是支持https的 兼容ijk 支持的播放格式 本地和网络播放器地址都支持)**

1.主要封装分为三层 为了方便携带 已经将三层封装在一个文件 

**1.player 2.operation panel 3.Gestures**

2.一定要实现代理方法 在碰到释放的时候释放播放器 不然又声音没影像会很麻烦






##2 m3u8 下载


KPm3u8DownLoad **（m3u8的下载原理是先将服务器的m3u8放到本地遍历当前m3u8文件中的ts 然后拆分ts 文件到数组 再一个个的下载下来之后然后将m3u8 文件生成本地ts 索引 然后要么转换格式合成mp4 要么直接拿着目录索引的m3u8就可以直接播放）**


1.单例模式下可以提供多个下载，在模型下可以多个下载 直接复用 已经提供了Demo

2.下载特别要注意m3u8的回调 和相应的缓存目录 本实例是根据ts的切片原理来下载回调给出当前的比例

3.infoplist 一定要支持http 不然会报错 已经支持https

4.如果是外链转的其他网站重定向的m3u8这个是不支持下载的必须是原始m3u8地址      **简而言之就是不支持你爬去了之后重定向的地址 可以播 但是下载不了**




#m3u8解密播放没那么难！
****
前情提要 m3u8 是现在流行的播放和下载的载体 ,轻量便捷
如果常规的link 直接播就行了 但是加密的m3u8 就需要了解其原理 

	例：http://fastwebcache.yod.cn/hls-enc-test/jialebi/stream.m3u8 
	这个url我们在Safari中可以直接打开,在Chrome中就被直接下载成stream.m3u8文
	件,我们用文本编辑器打开就会发现 里面包含
	 #EXT-X-KEY:METHOD=AES-128,URI="key.bin" METHOD 是加密方式 URI 是解密	用的秘钥路径 于是通过http://fastwebcache.yod.cn/hls-enc-test/jialebi/
	 key.bin 在Chrome 中我们下载到了加密文件

****
	
1.网络
	
	加密的和未加密的用ijkplayer 和avplayer 只要给出m3u8 http链接就直接可以播放 
	它们内部都做了对key的识别和解密（ijkplayer 里面需要在编译的时候在openssl添
	加--enable--protocol=crypto  avplayer 自带支持）

2.本地
	
	如果是未加密的m3u8 可以直接用url 来播放ijkplayer 和avplayer都可以
	但是如果是加密的m3u8 那么必须在本地构建一个本地服务器 然后再通过本地的path播放
	本质上还是和网络一样都是交给播放器处理
	
	

Demo下方

