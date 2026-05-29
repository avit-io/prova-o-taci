module ch01.Booleans where

open import bool
open import bool-thms
open import eq

-- Esercizi capitolo 1: Boolean Reasoning

-- Commutatività di &&
&&-comm : ∀ (b1 b2 : 𝔹) → b1 && b2 ≡ b2 && b1
&&-comm tt tt = refl
&&-comm tt ff = refl
&&-comm ff tt = refl
&&-comm ff ff = refl
