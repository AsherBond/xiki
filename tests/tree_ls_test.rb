require 'test/unit'
require 'el_mixin'
$:.unshift "../"
require '../tree_ls'

class TreeLsTest < Test::Unit::TestCase

  def call_clear_empty_dirs tree
    TreeLs.clear_empty_dirs_string tree.gsub(/^ *\|/, '')
  end

  # Should remove one empty dir
  def test_clear_empty_dirs!
    tree = call_clear_empty_dirs(
      "|/projects/
       |  empty/
       |  full/
       |    database.rhtml
       |")
    assert_no_match( /empty\//, tree )
    assert_match( /full\//, tree )
  end

  # Shouldn't remove quoted lines
  def test_clear_empty_dirs_with_quotes!
    tree = call_clear_empty_dirs(
      "|/projects/trunk/app/views/assets/details/
       |  hey/
       |  _database.rhtml
       |    |Database Type
       |    |Database Name
       |")
    assert_match( /Database Type/, tree )
    assert_match( /Database Name/, tree )
  end

  # Shouldn't remove quoted lines
  def test_clear_empty_dirs_with_quotes_with_slashes!
    tree = call_clear_empty_dirs(
      "|/projects/trunk/app/views/assets/details/
       |  hey/
       |  _database.rhtml
       |    |Database Type/
       |    |Database Name/
       |")
    assert_match( /Database Type/, tree )
    assert_match( /Database Name/, tree )
  end



  def test_paths_to_tree

    paths = %w[
      /projects/foo/a.txt
      /projects/foo/b.txt
      /other/c.txt
      ]

    tree =
      "|/other/
       |  c.txt
       |/projects/
       |  foo/
       |    a.txt
       |    b.txt
       |".gsub(/^ *\|/, '')

    assert_equal tree, TreeLs.paths_to_tree(paths)
  end

  def test_acronym_regexp
    str = TreeLs.acronym_regexp("mr")
    #puts str
    re = Regexp.new(str)
    assert "  mar_roon.txt" =~ re
    assert "  mar.rb" =~ re
    assert ! ("  mar,rb" =~ re)
    assert ! ("  mar_xu_rb" =~ re)
  end

end