Fixpoint div2 (n : nat) : nat :=
  match n with
  | 0 => 0
  |S 0 =>0
  | S (S p) => S (div2 p)
  end.


Print div2.

Eval compute in div2 0.
Eval compute in div2 1.
Eval compute in div2 3334.

Definition div2P (x y : nat) : Prop := 2 * y = x \/ 1 + 2 * y = x.

Check div2P.
Print div2P.


Require Export ArithRing.

Lemma th : forall x y : nat, div2P x y -> div2P (S (S x )) (S y).
intros x y.
unfold div2P.
intros.
elim H;[intro H0 | intro H1].
left.
rewrite <- H0.
ring_simplify.
reflexivity.
right.
rewrite <- H1.
ring_simplify.
reflexivity.
Qed.

Theorem Esquema :
forall P : nat -> Prop,
P 0 -> P 1 -> (forall n : nat, P n -> P (S (S n))) -> forall n : nat, P n.
Admitted.

Theorem compr : forall x:nat,(div2P x (div2 x)).
intros.

