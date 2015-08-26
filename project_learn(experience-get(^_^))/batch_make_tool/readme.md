用途：
1.可替换 AndroidManifest.xml 文件里特定字段并打包（可更换友盟统计渠道等）
	如果有必要在 r_AndroidManifests 文件夹下放入对应渠道的文件，但也需在 MakeTool.py 里做相应的修改
2.可替换 res 文件夹里对应的文件并打包（可换icon）
	在 r_ress 文件夹下放入对应渠道的文件，但也需在 MakeTool.py 里做相应的修改

使用方法：
用于渠道替换 channel 文件的每一行为一个渠道名称，替换 AndroidManifest.xml 对应的友盟统计渠道.
用 python 运行 MakeTool.py
