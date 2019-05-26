(* This program is free software; you can redistribute it and/or      *)
(* modify it under the terms of the GNU Lesser General Public License *)
(* as published by the Free Software Foundation; either version 2.1   *)
(* of the License, or (at your option) any later version.             *)
(*                                                                    *)
(* This program is distributed in the hope that it will be useful,    *)
(* but WITHOUT ANY WARRANTY; without even the implied warranty of     *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      *)
(* GNU General Public License for more details.                       *)
(*                                                                    *)
(* You should have received a copy of the GNU Lesser General Public   *)
(* License along with this program; if not, write to the Free         *)
(* Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA *)
(* 02110-1301 USA                                                     *)


Section constants.

Require Import Reals.
Require Import trajectory_const.
Require Import rrho.
Require Import trajectory_def.

Variable intr : Trajectory.
Variable evad : EvaderTrajectory.

Lemma Rle_201_250 : (MinSpeed <= 250)%R.
unfold MinSpeed in |- *; left; prove_sup.
Qed.

Lemma Rle_250_880 : (250 <= MaxSpeed)%R.
unfold MaxSpeed in |- *; left; prove_sup.
Qed.

(**********)
Definition V : TypeSpeed := mkTypeSpeed 250 Rle_201_250 Rle_250_880.
Definition r_V : R := r V.
Definition rho_V : R := rho V.
Definition AlertTime : R := 19%R.
Definition AlertRange : R := 1400%R.
Definition tstep : R := (/ 2)%R.
Definition MaxStep : R := 1%R.
Definition MaxT : R := 10%R.
Definition MinT : R := (MaxT - tstep)%R.
Definition m (t : R) : R :=
  let z := IZR 2 in (z * r_V * sin (rho_V * (t / z)))%R.
Definition m_rho_ub (t : R) : R :=
  let z := IZR 2 in (z * r_lb V * sin_lb (rho_lb V * (t / z)))%R.

(**********)
Record TimeT : Type := mkTimeT
  {val :> R; cond_1 : (MinT <= val)%R; cond_2 : (val <= MaxT)%R}.

(**********)
Lemma MinT_is_pos : (0 < MinT)%R.
Proof with trivial.
unfold MinT in |- *; unfold MaxT, tstep in |- *;
 apply Rmult_lt_reg_l with 2%R...
prove_sup...
rewrite Rmult_0_r; rewrite Rmult_minus_distr_l; rewrite <- Rinv_r_sym...
apply Rlt_trans with 1%R; prove_sup...
Qed.

(**********)
Theorem rho_ub_t_PI2 :
 forall (h : TypeSpeed) (t : TimeT), (rho_ub h * t < PI / 2)%R.
Proof with trivial.
intros; assert (H := cond_2 t)...
unfold MaxT in H; apply Rlt_trans with (PI_lb / 2)%R...
unfold rho_ub in |- *; cut (g < 33)%R...
cut (tan_ub_MaxBank < 4 / 5)%R...
cut (/ h < / 200)%R...
intros; generalize g_pos; intro H3; generalize tan_ub_MaxBank_pos; intro H4;
 generalize (Rinv_0_lt_compat h (TypeSpeed_pos h)); 
 intro H5...
generalize
 (Rmult_le_0_lt_compat g 33 tan_ub_MaxBank (4 / 5) 
    (Rlt_le 0 g H3) (Rlt_le 0 tan_ub_MaxBank H4) H2 H1)...
intro H6; generalize (Rmult_lt_0_compat g tan_ub_MaxBank H3 H4); intro H7...
assert
 (H8 :=
  Rmult_le_0_lt_compat (g * tan_ub_MaxBank) (33 * (4 / 5)) 
    (/ h) (/ 200) (Rlt_le 0 (g * tan_ub_MaxBank) H7) 
    (Rlt_le 0 (/ h) H5) H6 H0)...
apply Rlt_trans with (33 * / 200 * (4 / 5) * t)%R...
apply Rmult_lt_compat_r...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 t)...
rewrite Rmult_assoc; rewrite (Rmult_comm (/ 200)); unfold Rdiv in |- *;
 do 2 rewrite <- Rmult_assoc...
apply Rle_lt_trans with (33 * / 200 * (4 / 5) * 10)%R...
apply Rmult_le_compat_l...
left; apply Rmult_lt_0_compat...
apply Rmult_lt_0_compat; [ prove_sup | apply Rinv_0_lt_compat; prove_sup ]...
unfold Rdiv in |- *; apply Rmult_lt_0_compat;
 [ prove_sup | apply Rinv_0_lt_compat; prove_sup ]...
apply Rmult_lt_reg_l with 2%R...
prove_sup...
apply Rmult_lt_reg_l with 200%R...
prove_sup...
apply Rmult_lt_reg_l with 5%R...
prove_sup...
set (x := 200%R); set (y := 33%R); set (z := 10%R); set (u := 5%R);
 set (v := 4%R); set (w := 2%R)...
unfold Rdiv in |- *;
 replace (u * (x * (w * (PI_lb * / w))))%R with (x * PI_lb * u * (w * / w))%R;
 [ idtac | ring ]...
replace (u * (x * (w * (y * / x * (v * / u) * z))))%R with
 (w * y * v * z * (u * / u) * (x * / x))%R; [ idtac | ring ]...
repeat rewrite <- Rinv_r_sym; unfold x, y, z, u, v, w in |- *; try discrR...
unfold PI_lb in |- *; prove_sup...
apply Rinv_lt_contravar...
apply Rmult_lt_0_compat...
prove_sup...
apply Rlt_le_trans with MinSpeed...
unfold MinSpeed in |- *; prove_sup...
apply (v_cond1 h)...
apply Rlt_le_trans with MinSpeed...
unfold MinSpeed in |- *; prove_sup...
apply (v_cond1 h)...
unfold tan_ub_MaxBank in |- *; unfold Rdiv in |- *...
apply Rmult_lt_reg_l with 10%R...
prove_sup...
rewrite (Rmult_comm 10); rewrite Rmult_assoc; rewrite <- Rinv_l_sym...
rewrite Rmult_1_r; apply Rmult_lt_reg_l with 5%R...
prove_sup...
pattern 5%R at 1 in |- *; rewrite (Rmult_comm 5); do 2 rewrite Rmult_assoc;
 rewrite <- Rinv_l_sym...
prove_sup...
discrR...
discrR...
unfold g in |- *; unfold Rdiv in |- *; apply Rmult_lt_reg_l with 10%R...
prove_sup...
rewrite <- Rmult_comm; rewrite Rmult_assoc; rewrite <- Rinv_l_sym...
rewrite Rmult_1_r; prove_sup...
discrR...
unfold Rdiv in |- *; repeat rewrite <- (Rmult_comm (/ 2));
 apply Rmult_lt_compat_l...
apply Rinv_0_lt_compat; prove_sup...
assert (H0 := PI_approx); elim H0...
Qed.

(**********)
Theorem rho_t_PI2 : forall t : TimeT, (rho_V * t < PI / 2)%R.
Proof with trivial.
intro; generalize (rho_ub_t_PI2 V t); intro; unfold rho_V in |- *...
apply Rlt_trans with (rho_ub V * t)%R...
apply Rmult_lt_compat_r...
apply Rlt_le_trans with MinT; [ apply MinT_is_pos | apply (cond_1 t) ]...
apply rho_ub_0...
Qed.

(**********)
Lemma rho_t_2 : forall t : TimeT, (rho_V * t < 2)%R.
Proof with trivial.
intro t; apply Rlt_trans with (PI / 2)%R...
apply rho_t_PI2...
apply Rlt_le_trans with (PI_ub / 2)%R...
unfold Rdiv in |- *; repeat rewrite <- (Rmult_comm (/ 2))...
apply Rmult_lt_compat_l...
apply Rinv_0_lt_compat; prove_sup...
assert (H := PI_approx); elim H...
right; unfold PI_ub in |- *; unfold Rdiv in |- *.
change 4%R with (IZR (2 * 2)).
rewrite (mult_IZR 2 2).
 rewrite Rmult_assoc;
 rewrite <- Rinv_r_sym; [ apply Rmult_1_r | discrR ]...
Qed.

(**********)
Lemma r_V_is_pos : (0 < r_V)%R.
unfold r_V in |- *; unfold r in |- *; unfold Rdiv in |- *;
 apply Rmult_lt_0_compat;
 [ apply (TypeSpeed_pos V) | apply Rinv_0_lt_compat; apply rho_pos ].
Qed.

(**********)
Lemma rho_V_is_pos : (0 < rho_V)%R.
unfold rho_V in |- *; apply rho_pos.
Qed.

(**********)
Lemma m_le : forall t1 t2 : TimeT, (t1 <= t2)%R -> (m t1 <= m t2)%R.
Proof with trivial.
intros; unfold m in |- *; repeat rewrite Rmult_assoc...
repeat apply Rmult_le_compat_l...
left; simpl in |- *; prove_sup...
left; apply r_V_is_pos...
generalize (rho_t_PI2 t1); intro H1...
generalize (rho_t_PI2 t2); intro H2...
assert (Hyp : (0 < 2)%R)...
prove_sup0...
generalize
 (Rmult_lt_compat_l (/ 2) (rho_V * t1) (PI / 2) (Rinv_0_lt_compat 2 Hyp) H1)...
generalize
 (Rmult_lt_compat_l (/ 2) (rho_V * t2) (PI / 2) (Rinv_0_lt_compat 2 Hyp) H2)...
replace (/ 2 * (PI / 2))%R with (PI / 4)%R...
clear H1 H2; intros H1 H2...
rewrite Rmult_comm in H1...
rewrite Rmult_comm in H2...
unfold Rdiv in |- *...
generalize (cond_1 t1)...
generalize (cond_1 t2)...
generalize MinT_is_pos; intro H7...
intros H3 H4...
generalize (Rlt_le_trans 0 MinT t1 H7 H4); clear H4; intro H4...
generalize (Rlt_le_trans 0 MinT t2 H7 H3); clear H3; intro H3...
apply sin_incr_1...
left; apply Rlt_trans with 0%R...
apply _PI2_RLT_0...
repeat simple apply Rmult_lt_0_compat...
apply rho_V_is_pos...
apply Rinv_0_lt_compat; simpl in |- *; prove_sup0...
left; apply Rlt_trans with (PI / 4)%R...
rewrite <- Rmult_assoc...
apply PI4_RLT_PI2...
left; apply Rlt_trans with 0%R...
apply _PI2_RLT_0...
repeat simple apply Rmult_lt_0_compat...
apply rho_V_is_pos...
apply Rinv_0_lt_compat; simpl in |- *; prove_sup0...
left; apply Rlt_trans with (PI / 4)%R...
rewrite <- Rmult_assoc...
apply PI4_RLT_PI2...
apply Rmult_le_compat_l...
left; apply rho_V_is_pos...
apply Rmult_le_compat_r...
left; apply Rinv_0_lt_compat; simpl in |- *; prove_sup0...
unfold Rdiv in |- *; rewrite (Rmult_comm (/ 2)); rewrite Rmult_assoc;
 rewrite <- Rinv_mult_distr...
Qed.

(**********)
Lemma m_rho_ub_0 : forall t : TimeT, (m_rho_ub t <= m t)%R.
Proof with trivial.
intro; unfold m_rho_ub, m in |- *; repeat rewrite Rmult_assoc;
 apply Rmult_le_compat_l...
left; simpl in |- *; prove_sup0...
cut (0 <= r_lb V <= r_V)%R...
cut (0 <= sin_lb (rho_lb V * (t / 2)) <= sin (rho_V * (t / 2)))%R...
intros; elim H; intros H1 H2; elim H0; intros H3 H4...
apply Rmult_le_compat...
cut (0 < rho_lb V * (t / 2) <= rho_V * (t / 2))%R...
cut (rho_V * (t / 2) <= PI / 2)%R...
intros; elim H0; intros H1 H2; split...
left; apply sin_lb_gt_0...
apply Rle_trans with (rho_V * (t / 2))%R...
apply Rle_trans with (sin (rho_lb V * (t / 2)))...
generalize
 (SIN (rho_lb V * (t / 2)) (Rlt_le 0 (rho_lb V * (t / 2)) H1)
    (Rle_trans (rho_lb V * (t / 2)) (PI / 2) PI
       (Rle_trans (rho_lb V * (t / 2)) (rho_V * (t / 2)) (PI / 2) H2 H)
       (Rlt_le (PI / 2) PI PI2_Rlt_PI)))...
intro H3; elim H3; intros H4 H5...
apply sin_incr_1...
left; apply (Rlt_trans (- (PI / 2)) 0 (rho_lb V * (t / 2)) _PI2_RLT_0 H1)...
apply Rle_trans with (rho_V * (t / 2))%R...
left;
 apply
  (Rlt_trans (- (PI / 2)) 0 (rho_V * (t / 2)) _PI2_RLT_0
     (Rlt_le_trans 0 (rho_lb V * (t / 2)) (rho_V * (t / 2)) H1 H2))...
left; apply Rlt_trans with (PI / 4)%R...
generalize (rho_t_PI2 t); intro H; unfold Rdiv in |- *;
 replace (/ 4)%R with (/ 2 * / 2)%R...
repeat rewrite <- Rmult_assoc; apply Rmult_lt_compat_r...
apply Rinv_0_lt_compat; prove_sup0...
rewrite <- Rinv_mult_distr...
discrR...
discrR...
apply PI4_RLT_PI2...
split...
unfold Rdiv in |- *; repeat simple apply Rmult_lt_0_compat...
apply rho_lb_pos...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 t)...
apply Rinv_0_lt_compat; prove_sup0...
apply Rmult_le_compat_r...
left; unfold Rdiv in |- *; apply Rmult_lt_0_compat...
apply Rlt_le_trans with MinT...
apply MinT_is_pos...
apply (cond_1 t)...
apply Rinv_0_lt_compat; prove_sup0...
unfold rho_V in |- *...
left; apply rho_lb_0...
split...
unfold r_lb in |- *...
unfold Rdiv in |- *; left; apply Rmult_lt_0_compat...
apply (TypeSpeed_pos V)...
apply Rinv_0_lt_compat; apply rho_ub_pos...
unfold r_V in |- *; left; apply r_lb_0...
Qed.

(**********)
Lemma m_rho_T_pos : forall t : TimeT, (0 < m t)%R.
Proof with trivial.
intro t; unfold m in |- *; repeat simple apply Rmult_lt_0_compat...
simpl in |- *; prove_sup0...
apply r_V_is_pos...
generalize (cond_1 t); generalize MinT_is_pos; intros H H0;
 generalize (Rlt_le_trans 0 MinT t H H0); clear H; 
 intro H; apply sin_gt_0...
repeat simple apply Rmult_lt_0_compat...
apply rho_V_is_pos...
unfold Rdiv in |- *; apply Rmult_lt_0_compat;
 try (apply Rinv_0_lt_compat; simpl in |- *; prove_sup0)...
generalize (rho_t_PI2 t); intro H1; assert (Hyp : (0 < 2)%R)...
prove_sup0...
generalize
 (Rmult_lt_compat_r (/ 2) (rho_V * t) (PI / 2) (Rinv_0_lt_compat 2 Hyp) H1);
 rewrite Rmult_assoc; replace (PI / 2 * / 2)%R with (PI / 4)%R...
intro H2; apply Rlt_trans with (PI / 4)%R...
apply (Rlt_trans (PI / 4) (PI / 2) PI PI4_RLT_PI2 PI2_Rlt_PI)...
unfold Rdiv in |- *; rewrite Rmult_assoc; rewrite <- Rinv_mult_distr...
Qed.

Variable T : TimeT.

Definition MaxDistance : R := (V * T + ConflictRange)%R.
Definition MinDistance : R := (m T - ConflictRange)%R.
Definition MaxDistance_ub : R := (V * MaxT + ConflictRange)%R.
Definition MinDistance_lb : R := (m_rho_ub MinT - ConflictRange)%R.

(**********)
Lemma MaxDistance_ub_0 : (MaxDistance <= MaxDistance_ub)%R.
unfold MaxDistance, MaxDistance_ub in |- *.
rewrite (Rplus_comm (V * T)).
rewrite (Rplus_comm (V * MaxT)).
apply Rplus_le_compat_l.
apply Rmult_le_compat_l.
left; apply (TypeSpeed_pos V).
apply (cond_2 T).
Qed.

(**********)
Lemma MinT_MaxT : (MinT <= MaxT)%R.
unfold MinT in |- *; pattern MaxT at 2 in |- *; rewrite <- (Rplus_0_r MaxT).
unfold Rminus in |- *; apply Rplus_le_compat_l.
unfold tstep in |- *; rewrite <- Ropp_0; left; apply Ropp_lt_gt_contravar;
 apply Rinv_0_lt_compat; prove_sup.
Qed.

(**********)
Lemma MinDistance_lb_0 : (MinDistance_lb <= MinDistance)%R.
Proof with trivial.
unfold MinDistance_lb, MinDistance in |- *; unfold Rminus in |- *;
 rewrite (Rplus_comm (m_rho_ub MinT)); rewrite (Rplus_comm (m T));
 apply Rplus_le_compat_l...
cut (MinT <= MinT)%R...
intro H; apply Rle_trans with (m MinT)...
apply (m_rho_ub_0 (mkTimeT MinT H MinT_MaxT))...
apply (m_le (mkTimeT MinT H MinT_MaxT) T)...
simpl in |- *; apply (cond_1 T)...
right...
Qed.

(*** Easy to prove with constructive reals ***)
(*** Verified with Mapple                  ***)
Axiom MinDistance_lb_majoration : (V + ConflictRange < MinDistance_lb)%R.

(**********)
Lemma MinDistance_lb_pos : (0 < MinDistance_lb)%R.
Proof with trivial.
apply Rlt_trans with (V + ConflictRange)%R...
unfold V, ConflictRange in |- *; simpl in |- *; prove_sup...
apply MinDistance_lb_majoration...
Qed.

(**********)
Lemma MinDistance_pos : (0 < MinDistance)%R.
apply Rlt_le_trans with MinDistance_lb.
apply MinDistance_lb_pos.
apply MinDistance_lb_0.
Qed.

Definition MinBeta : R := (539 / 1000)%R.

End constants.