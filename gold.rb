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
