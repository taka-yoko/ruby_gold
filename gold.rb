# Ruby Association Certified Ruby Programmer Gold 学習のための備忘録。学んだことのメモと復習に使用

# REx より

# 定数の参照はレキシカルに行われる(関数、クラスを定義した時点でスコープが決まる)
# 下記の場合、M::C#awesome_methodのコンテキストにCONSTが見つからないため、例外が発生する。
# M::CONSTであれば"Hello, world"と表示される。
#####
module M
  CONST = "Hello, world"
end

class M::C
  def awesome_method
    CONST
  end
end

p M::C.new.awesome_method
# => `awesome_method': uninitialized constant M::C::CONST (NameError)
#####

# 整数、少数の演算
p 4/5
# => 0
p 4.0/5
# => 0.8
p 4/5r
# => (4/5)

# メソッド内での定数の更新
class C
  VAR = 0
  def VAR= v
    VAR = v
  end
end
# => VAR = v としている所で dynamic constant assignment
# メソッド内の定数の更新は文法エラーになる

# 可変長引数
def hoge *args
  p *args
end

hoge [1, 2, 3]
# => [1, 2, 3]

def fuga *args
  p args[0]
end

fuga [1, 2, 3]
# => [1, 2, 3]

def foo *args
  p args
end

foo [1, 2, 3]
# => [[1, 2, 3]]
