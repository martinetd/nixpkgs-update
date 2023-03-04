{-# Language OverloadedStrings #-}
module CheckSpec where

import qualified Data.Text as T
import Test.Hspec
import qualified Check

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "version check" do
    let seaweedVersion234 = "version 30GB 2.34 linux amd64"
    it "finds the version when present" do
      Check.hasVersion "The version is 2.34" "2.34" `shouldBe` True
      Check.hasVersion "The version is 2.34." "2.34" `shouldBe` True
      Check.hasVersion "2.34 is the version" "2.34" `shouldBe` True
      Check.hasVersion seaweedVersion234 "2.34" `shouldBe` True

    it "doesn't produce false positives" do
      Check.hasVersion "The version is 12.34" "2.34" `shouldBe` False
      Check.hasVersion "The version is 2.345" "2.34" `shouldBe` False
      Check.hasVersion "The version is 2.35" "2.34" `shouldBe` False
      Check.hasVersion "2.35 is the version" "2.34" `shouldBe` False
      Check.hasVersion "2.345 is the version" "2.34" `shouldBe` False
      Check.hasVersion "12.34 is the version" "2.34" `shouldBe` False
      Check.hasVersion seaweedVersion234 "2.35" `shouldBe` False

    it "negative lookahead construction" do
      Check.versionWithoutPath "/nix/store/z9l2xakz7cgw6yfh83nh542pvc0g4rkq-geeqie-2.0.1" "2.0.1" `shouldBe` "^(?!.*z9l2xakz7cgw6yfh83nh542pvc0g4rkq-geeqie-).*2\\.0\\.1"
      Check.versionWithoutPath "/nix/store/z9l2xakz7cgw6yfh83nh542pvc0g4rkq-abc" "2.0.1" `shouldBe` "^(?!.*z9l2xakz7cgw6yfh83nh542pvc0g4rkq-abc).*2\\.0\\.1"
