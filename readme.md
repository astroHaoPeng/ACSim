 __（注意）　このプログラムは開発中です!!__

# 概要
筑波大学「結」プロジェクトが開発中の次世代CubeSat "ITF-3"のための姿勢制御シミュレーターです。

本シミュレータのモジュールは、「環境部」と「衛星部」に大別されます。「環境部」では、外乱や衛星のダイナミクス、軌道やセンサ・アクチュエータのモデルを計算しています。「衛星部」では、姿勢決定、及び姿勢制御のアルゴリズムなど、衛星内部での計算をモデル化しています。シミュレータのフローチャートは"readme_fig.jpg"を参照してください。

# 開発スケジュール

|  モジュール  |  完成予定  |
| ---- | ---- |
|  要求分析  |  2019年10月  |
|  仕様決定  |  2019年11月  |
|  軌道計算部門開発  |  2019年12月  |
|  衛星内環境部門開発  |  2020年2月  |
|  衛星外環境部門開発  |  2020年2月  |
|  衛星ダイナミクス開発  |  2020年2月  |
|  技術書典向け執筆  |  2020年2月  |
|  可視化開発  |  2020年3月  |
|  衛星部門開発  |  2020年5月  |
|  開発完了 | 2020年7月 |
 
 # 構造について
- main.jlが全てを呼び出す
    - モジュール内では、orbit.jl、 static_model.jl、dynamic_model.jl、dynamics.jl、satellite.jlが全てを呼び出す。
- main_light.jl は、計算済みの軌道情報を格納してあるHDF5ファイルを呼び出して実行
- 衛星の状態を次のあらゆるパラメータは、常にmain.jlが保持する
    - 時刻
    - 衛星の位置、速度、角速度、（加速度）
    - DCM
    
 ### ディレクトリ構造
```
main.jl
  |- orbit：軌道計算
  |- external_model：衛星外環境
  |- internal_mode：衛星内環境
  |- dynamics：衛星ダイナミクス
  |- stellite：衛星モデル
  |- figs：出力画像
  |- plot："plot"と"Makie"によるplot関数群
```

# 時刻について
- 基本的に時刻はDateTime型で管理する。必要に応じてDate型やユリウス通日に変換。

# 座標系について
6つの[座標系](https://en.wikipedia.org/wiki/Celestial_coordinate_system)（[Jaxa 人工衛星の力学と制御:宇宙機ダイナミクス・姿勢制御技術ユニット](https://repository.exst.jaxa.jp/dspace/handle/a-is/26346?locale=ja)参照）
1. 太陽中心黄道面基準慣性座標系(SEEcF?, heliocentric?)
太陽を中心として、秋分点方向をx軸とし、地球軌道面に垂直上向きにz軸を取った座標系。英語では、[Galactic coordinate system](https://en.wikipedia.org/wiki/Galactic_coordinate_system)と書かれる。
1. 地球中心黄道面基準慣性座標系(ECEcF?)
英語では、[Ecliptic coordinate system](https://en.wikipedia.org/wiki/Ecliptic_coordinate_system)と書かれる。
1. 地球中心赤道面基準慣性座標系(ECI)
Earth-Centered Inertial。[Geocentric equatorial coordinates](https://en.wikipedia.org/wiki/Equatorial_coordinate_system)とも。
1. 地球中心赤道面基準地球固定座標系(ECEF)
地球中心から、緯度0度、経度0の方向にx軸を、北極にz軸を取った座標系。Earth-Centered, Earth-Fixed。プログラム上基準となる座標系。
1. 軌道座標系(SEOF?)
進行方向をx軸、地球中心をz軸とする座標系。
1. 衛星座標系(SCSF?)
英語では、[Satellite Coordinates](https://gssc.esa.int/navipedia/index.php/Satellite_Coordinates)と書かれる。←ほんまか？
1. geodetic座標系(geodetic)
衛星の位置を緯度,経度,高度で表す座標系。主にECEF→geodeticで衛星の高度を求める。

# コーディング規約について
- コーディング規約[PEP8](https://qiita.com/simonritchie/items/bb06a7521ae6560738a7#命名規則)に則る。と思ってたが、ファイル名命名規則だけ変更！
ただし、固有名詞はこの限りではない。（例えばDCMとか） 
    - 変数名、関数名は小文字とアンダースコア(val_num)
    - クラス名は先頭大文字パスカルケース(HogeClass)
    - 定数名は全て大文字とアンダースコア(CONST_HOGE)
    - ~~ファイル名は全て小文字、アンダースコアなし(hogemodel)~~
    - ファイル名は全て小文字、アンダースコア(hoge_model)
- [dockstring](https://docs.julialang.org/en/v1/manual/documentation/index.html)をできるだけ記述する。以下、例。
```julia
"""
static_model(datetime,r_ecef)

静的環境モデルに関わる全ての計算

## Arguments
- `datetime`: 時刻
- `r_ecef`: 衛星位置

## Returns
- `sun_vec`: 太陽方向ベクトル
- `shot_vec`: 撮影地点方向ベクトル
- `mag_vec`: 地磁場方向ベクトル
- `atoms_dens`: 大気密度スカラー

"""
function static_model(datetime,r_ecef)
    hogehoge
    return mag_vel, sun_vec, atoms_dens
end
```

# main_light.jlについて
軌道計算には、軌道モデルのダウンロードが必要であるため、オンラインである必要があります。
main_light.jlは、計算済みの軌道データが格納されたHDF5ファイルを読み込んでおり軌道計算は行わないので、オフラインで実行可能です。また、ちょっと早く実行できます。


# メモ

## 最速gitの使い方
1. `git pull`
1. コードをごにょごにょ編集
1. `git add -A`
1. `git commit -m "Message"`
1. `git push`

## 最速ブランチの切り方
1. ブランチを切る元になるブランチに移動する（例：`git branch master`）
1. 新しいローカルブランチを作る（`git checkout -b new-branch`）
1. 新しく作ったブランチをリモート (GtiHub) に反映させる (`git push`)
