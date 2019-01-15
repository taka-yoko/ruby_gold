Ruby Association Certified Ruby Programmer Gold 学習のための備忘録。学んだことのメモと復習に使用

---

# 定数の参照
定数の参照はレキシカルに行われる(関数、クラスを定義した時点でスコープが決まる)
下記の場合、`M::C#awesome_method`のコンテキストにCONSTが見つからないため、例外が発生する。
`M::CONST`であれば"Hello, world"と表示される。

```ruby
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
```

以下のようにネストした場合は、上位の階層を探索するので`Hello, world`と表示される。

```ruby
module M
  CONST = "Hello, world"
end

module M
  class C
    def awesome_method
      CONST
    end
  end
end

p M::C.new.awesome_method # => "Hello, world"
```

---

# 整数、少数の演算

```ruby
p 4/5
# => 0
p 4.0/5
# => 0.8
p 4/5r
# => (4/5)
```

---

# メソッド内での定数の更新

```ruby
class C
  VAR = 0
  def VAR= v
    VAR = v
  end
end
# => VAR = v としている所で dynamic constant assignment
# メソッド内の定数の更新は文法エラーになる
```

---

# 可変長引数
```ruby
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
```

---

# Module#class_eval
`Module#class_eval`は、引数に文字列またはブロックを受け取る
https://docs.ruby-lang.org/ja/latest/method/Module/i/class_eval.html

引数が文字列の場合は、定数とクラス変数のスコープは、自身のモジュール定義式内と同じスコープになる

```ruby
class C1
  X = 'X'
  @@c_var = 'c_var'
end

C1.class_eval(<<-CODE)
  def foo
    p X
    p @@c_var
  end
CODE

C1.new.foo
# => "X"
"c_var"
```

引数がブロックの場合は、定数とクラス変数のスコープはブロックの外側のスコープになる

```ruby
class C2
  X = 'X'
  @@c_var = 'c_var'
end

X = 'global X'
C2.class_eval do
  def foo
    p X
  end
end

C2.new.foo
# => "global X"
```

---

# 例外処理

```ruby
begin
  # 何らかの処理
begin
rescue
  # 例外が発生したら
else
  # 例外がなかったら
ensure
  # 例外があってもなくても
end

# ex.
begin
  1/1
rescue StandardError => e
  p e
else
  p "else"
ensure
  p "ensure"
end
# => "else"
# => "ensure"

begin
  1/0
rescue StandardError => e
  p e
else
  p "else"
ensure
  p "ensure"
end
# => #<ZeroDivisionError: divided by 0>
# => "ensure"
```

---
  
# class, moduleの探索順序
  
後でprependした方が先に探索される

```ruby
module M1
end

module M2
end

class C
  prepend M1
  prepend M2
end

p C.ancestors
# => [M2, M1, C, Object, Kernel, BasicObject]
  
## prependで複数のmoduleを引数にした場合は、前の引数から探索される
module M1
end

module M2
end

class C
  prepend M1, M2
end

p C.ancestors
# => [M1, M2, C, Object, Kernel, BasicObject]
```

---
  
# 正規表現
`\w`は`大文字、小文字、数字とアンダーバー(_)`にマッチします。

---

# モジュールのネスト  
`Module.nesting`はネストの状態を表示する。

```ruby
module S
  p Module.nesting # => [S]
end

# インデントでネストの状態を記述した場合は、ネストの状態すべてが表示される
module S
  module C
    p Module.nesting # => [S::C, S]
  end
end

# プレフィックスでネストを記述した場合は、内側にあるモジュールしかネストの状態は表示されない
module S::C
  p Module.nesting # => [S::C]
end
```

---

# 例外処理

```ruby
begin
  raise "Err!" # => 例外クラスを省略した場合はRuntimeErrorを投げる
rescue => e # => 例外クラスを省略した場合は StandardErrorを補足
  puts e.class # => RuntimeError
end
```

---

# JSON文字列 <=> Hash Object の変換

```ruby
require 'json'

# JSON文字列 -> Hash Object
json = <<JSON
{
  "price":100,
  "order_code":200,
  "order_date":"2018/09/20",
  "tax":0.8
}
JSON

hash = JSON.load json
p hash # => {"price"=>100, "order_code"=>200, "order_date"=>"2018/09/20", "tax"=>0.8}
hash = JSON.parse json
p hash # => {"price"=>100, "order_code"=>200, "order_date"=>"2018/09/20", "tax"=>0.8}


# Hash Object -> JSON文字列
hash = { name: "Kazuyoshi Morita", nickname: "Tamori" }

p hash.to_json # => "{\"name\":\"Kazuyoshi Morita\",\"nickname\":\"Tamori\"}"
p JSON.dump hash # => "{\"name\":\"Kazuyoshi Morita\",\"nickname\":\"Tamori\"}"
```

---

# Refinementを複数回行った場合の継承

```ruby
class C
  def m1
    200
  end
  
  def m2
    "World"
  end
end

module R1
  refine C do
    def m1 
      100
    end
    
    def m2
      "Hello" + super
    end
  end
end

module R2
  refine C do
    def m1
      100 + super
    end
  end
end

using R1
using R2

puts C.new.m1 # => 300 最後に書いたR2が優先される。R2内のm1でsuperが呼ばれているが、これはCのm1が呼ばれる。R1のm1は無効。
puts C.new.m2 # => HelloWorld R2にはm2がないので、R1のm2が呼ばれる。
```

---

# 定数とクラス変数のスコープ

クラス変数は定数と違い、上位のスコープまで探索は行わない。

```ruby
module M
  CONST = 100
  @@val = 200
end


module M
  class C
    p CONST # => 100
    p @@val # => NameError
  end
end
```

---

# Module内のメソッド

モジュール内のメソッドはプライベートメソッドとなるため、以下のようにアクセスできない。

```ruby
module M
  def m
    "m"
  end
end

p M.m # => NoMethodError 
p M::m # => NoMethodError
```

`module_function`を追加すると、クラスメソッドのようにアクセスできる。

```ruby
module M
  def m
    "m"
  end
  
  module_function :m
end

p M.m # => m
p M::m # => m
```

---

# newメソッド

`method_defined?`メソッドは、クラスやモジュールに`インスタンスメソッド`が定義されているかどうかを調べます。

```ruby
# Class#new は存在する
p Class.method_defined? :new #=> ture
# str.new("Awesome String") Stringのインスタンスに対してnewは呼べない
p String.method_defined? :new #=> false
# 
p Class.singleton_class.method_defined? :new #=> ture
# String.new("Awesome String") newはClassのインスタンスメソッド
p String.singleton_class.method_defined? :new #=> ture
```

---

# 定数の探索

```ruby

class Human
  NAME = "Unknown"

  def self.name
    p NAME # => "Unknown"
    p const_get(:NAME) # => "Yukichi" selfに定義された定数を探索する。
  end
end

class Fukuzawa < Human
  NAME = "Yukichi"
end

Fukuzawa.name
```
