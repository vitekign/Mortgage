(defrule start_the_system
	?p <- (start)
	=>
	(printout t "Welcome to the mortgage approval expert system" crlf)
	(printout t "Please, enter your credit score: ")
	(assert (credit_score (read)))
	(retract ?p)
	;to calculate debt to income ratio
	(printout t "Please, enter recurring monthly debt: ")
	(assert (monthly_debt (read)))
	(printout t "Please, enter your gross monthly income: " )
	;(printout t "Total personal income, before accounting for taxes or deductions: ")
	(assert (total_personal_monthly_income (read)))
	;to calculate Loan to Value ratio
	(printout t "Please, enter current appraised value or market value of home: ")
	(assert (home_market_value (read)))
	(printout t "Please, enter the amount of your downpayment: ")
	(assert (home_downpayment (read)))

)

(defrule calulate_debt_to_income_ratio
	(monthly_debt ?m_debt)
	(total_personal_monthly_income ?tot_income)
	=>
	(bind ?dti (/ ?m_debt ?tot_income))
	(assert (dti ?dti))
	(printout t "The Debt To Income Ratio is: " ?dti crlf)
)

(defrule calulate_loan_to_value_ratio
	(home_market_value ?h_value)
	(home_downpayment ?h_downpayment)
	=>
	(bind ?loan_amount (- ?h_value ?h_downpayment))
	(assert (loan_amount ?loan_amount))
	(bind ?ltv (/ ?loan_amount ?h_value))
	(assert (ltv ?ltv))
	(printout t "The Loan To Value Ratio is: " ?ltv crlf)
)

(defrule define_bracket_from_credit_score
	(credit_score ?credit_score)
	(test (> ?credit_score 449))
	(test (< ?credit_score 641))
	=>
	(assert (credit_score_bracket low))
	(printout t "--------------------------------------------------" crlf)
	(printout t "Unfortunately, your credit score is extremely low. " crlf)
)

(defrule bad_credit_score_reason
	(credit_score_bracket low)
	(home_downpayment ?) ;just to avoid firing prematurely 
	=>
	(printout t "Let us find out the reason: " crlf)
	(printout t "1. You have had bankruptcies. " crlf)
	(printout t "2. You have made late credit card payments. " crlf)
	(printout t "3. You have collection accounts. " crlf)
	(assert (bad_credit_score_reason (read)))
)
(defrule bad_credit_score_reason_1
	(credit_score_bracket low)
	(home_downpayment ?)
	(bad_credit_score_reason 1)
	=>
	(assert (ext_low_credit_score bankruptcies))
)
(defrule bad_credit_score_reason_2
	(credit_score_bracket low)
	(home_downpayment ?)
	(bad_credit_score_reason 2)
	=>
	(assert (ext_low_credit_score late_payments))
)
(defrule bad_credit_score_reason_3
	(credit_score_bracket low)
	(home_downpayment ?)
	(bad_credit_score_reason 3)
	=>
	(assert (ext_low_credit_score collection_accounts))
)
(defrule find_out_type_of_bankruptcy
	(ext_low_credit_score bankruptcies)
	=>
	(printout t "Please pick the type of bankruptcy: " crlf)
	(printout t "1. You have had chapter 7 type of bankruptcy" crlf)
	(printout t "2. You have had chapter 13 type of bankruptcy" crlf)
	(assert (find_out_type_of_bankruptcy (read)))
)
(defrule define_a_type_of_bankruptcy_chapter7
	(find_out_type_of_bankruptcy 1)
	=>
	(assert (type_of_bankruptcy chapter7))
)

(defrule define_a_type_of_bankruptcy_chapter13
	(find_out_type_of_bankruptcy 2)
	=>
	(assert (type_of_bankruptcy chapter13))
)

(defrule how_long_ago_bank_happend_for_ch7
	(type_of_bankruptcy chapter7)
	=>
	(printout t "How many years have passed since your bankruptcy? " crlf)
	(assert (bankruptcy_years (read)))
)

(defrule how_long_ago_bank_happend_for_ch13
	(type_of_bankruptcy chapter13)
	=>
	(printout t "How many years have passed since your bankruptcy? " crlf)
	(assert (bankruptcy_years (read)))
)

(defrule find_out_type_of_late_payents
	(ext_low_credit_score late_payments)
	=>
	(printout t "Please choose the type of late payments: " crlf)
	(printout t "1. You have 30-60 day late payments" crlf)
	(printout t "2. You have 60-90 day late payments" crlf)
	(printout t "3. You have 90 and more day late payments" crlf)
	(assert (find_out_type_of_late_payents (read)))
)

(defrule state_type_of_bank
	(find_out_type_of_late_payents 1)
	=>
	(assert (type_of_late_payments 30-60_family))
)

(defrule find_out_frequency_of_30-60_late-payments_family
	(type_of_late_payments 30-60_family)
	=>
	(printout t "Please enter the number of late payments [up to 10] " crlf)
	(assert (number_of_30-60-late-payments (read)))
)

;**************************************
;      Fuzzy Set Definition           *
;**************************************

(deftemplate CreditScore
	450 640 points 
	( (Neg (497.5 1) (545 0))
	  (Avg (487.5 0) (545 1) (592.5 0))
	  (Pos (545 0) (592.5 1))))
	  
(deftemplate DTI
	0 1 dti_points
	( (Pos (0.05 1) (0.20 0))
	  (Avg (0.05 0) (0.20 1) (0.43 1))
	  (Neg (0.20 0) (0.43 1))))

(deftemplate LTV
	0 1 ltv_points
	( (Pos (0.8 1) (0.875 0))
	  (Avg (0.8 0) (0.875 1) (0.95 0))
	  (Neg (0.875 0) (0.95 1))))

(deftemplate Time
	0 10 years
	( (Rec (3.5 1) (5 0))
	  (Med (3.5 0) (5 1 ) (6.5 0))
	  (Far (5 0) (6.5 1))))
	  
	  
(deftemplate Approval
	0 10 points
	( (NO (3.5 1) (5 0))
	  (HD (3.5 0) (5 1 ) (6.5 0))
	  (YES (5 0) (6.5 1))))
	  
	  
(deftemplate DecideRate
	2.75 8.75 percents
  ( ( LLL (3.5 1) (4.25 0))
	( LL  (3.5 0) (4.25 1) (5 0))
	( L   (4.25 0) (5 1) (5.75 0))
	( A   (5 0) (5.75 1) (6.5 0))
	( H   (5.75 0) (6.5 1) (7.25 0))
	( HH  (6.5 0) (7.25 1) (8.0 0))
	( HHH (7.25 0) (8.0 1))))

(deftemplate DecideOutlook
	0 15 points
	( ( NNNN (1.5 1) (3 0))
	  ( NNN (1.5 0) (3 1) (4.5 0))
	  ( NN (3 0) (4.5 1) (6 0))
	  ( N (4.5 0) (6 1) (7.5 0))
	  ( A (6 0) (7.5 1) (9 0))
	  ( P (7.5 0) (9 1) (10.5 0))
	  ( PP (9 0) (10.5 1) (12 0))
	  ( PPP (10.5 0) (12 1) (13.5 0))
	  ( PPPP (12 0) (13.5 1))))
	  
 (deftemplate Outlook
   0 15 points
	( ( NNNN (1.5 1) (3 0))
	  ( NNN (1.5 0) (3 1) (4.5 0))
	  ( NN (3 0) (4.5 1) (6 0))
	  ( N (4.5 0) (6 1) (7.5 0))
	  ( A (6 0) (7.5 1) (9 0))
	  ( P (7.5 0) (9 1) (10.5 0))
	  ( PP (9 0) (10.5 1) (12 0))
	  ( PPP (10.5 0) (12 1) (13.5 0))
	  ( PPPP (12 0) (13.5 1))))
 
 (deftemplate Frequency
 0 10 times
 	( (one (1 1) (2.5 0))
	  (two-three (1 0) (2.5 1) (4 0))
	  (four (2.5 0) (4 1))))



;**************************************
;           Fuzzification             *
;**************************************

(defrule fuzzify_inputs
	(dti ?a)
	(ltv ?b)
	(credit_score ?d)
	=>
	(assert (DTI (?a 0) (?a 1) (?a 0)))
	(assert (LTV (?b 0) (?b 1) (?b 0)))
	(assert (CreditScore (?d 0) (?d 1) (?d 0)))
)

(defrule fuzzify_decide_outlook
	(overall_outlook ?o)
	=>
	(assert (Outlook (?o 0) (?o 1) (?o 0)))
)

(defrule fuzzify_time_ch7_or_ch_13
	(bankruptcy_years ?b)
	=>
	(assert (Time (?b 0) (?b 1) (?b 0)))
)

(defrule fuzzify_30-60-late-payments
	(number_of_30-60-late-payments ?l)
	=>
	(assert (Frequency (?l 0) (?l 1) (?l 0)))
)

;**************************************
;           De-Fuzzification          *
;**************************************

(defrule defuzzify_outputs
	(declare (salience -1))
	?f <- (DecideOutlook ?)
	=>
	(bind ?t (moment-defuzzify ?f))
	(assert (overall_outlook ?t))
)

(defrule defuzzify2 
	(declare (salience -2))
	?f <- (DecideRate ?)
	?a <- (Approval ?)
	=>
	(bind ?t (moment-defuzzify ?f))
	(assert (rate_points ?t))
	(bind ?apr (moment-defuzzify ?a))
	(assert (points_approval ?apr))
)

(defrule defuzzify1 
	(declare (salience -1))
	?f <- (DecideOutlook ?)
	=>
	(bind ?t (moment-defuzzify ?f))
	(assert (overall_outlook ?t))
)
	

;*******************************************
;  Print the final decision on the scree   *
;*******************************************

(defrule print_appr_dec_1
	(declare (salience -2))
	(rate_points ?rate)
	(points_approval ?points)
	(test (< ?points 3.5))
	=>
	(printout t "Unfortunately, we could not approve your loan." crlf)
)

(defrule print_appr_dec_2
	(declare (salience -2))
	(rate_points ?rate)
	(points_approval ?points)
	(test (> ?points 3.5))
	(test (< ?points 6.5))
	=>
	(printout t "Your mortgage needs to be reviewed by one of our loan officers" crlf)
)

(defrule print_appr_dec_3
	(declare (salience -2))
	(rate_points ?rate)
	(points_approval ?points)
	(test (> ?points 6.5))
	=>
	(printout t "Congratulations, your mortgage has been approved." crlf)
	(printout t "Your rate is: " ?rate crlf )
)


;*************************************
;            chapter 7  FAM          *
;*************************************

(defrule CHAP7_1
(type_of_bankruptcy chapter7)
(Outlook  N)
(Time  Rec)
=>
(assert (DecideRate HHH))
(assert (Approval NO)))

(defrule CHAP7_2
(type_of_bankruptcy chapter7)
(Outlook  N)
(Time  Med)
=>
(assert (DecideRate HHH))
(assert (Approval NO)))

(defrule CHAP7_3
(type_of_bankruptcy chapter7)
(Outlook  N)
(Time  Far)
=>
(assert (DecideRate HH))
(assert (Approval NO)))

(defrule CHAP7_4
(type_of_bankruptcy chapter7)
(Outlook  NN)
(Time  Rec)
=>
(assert (DecideRate HHH))
(assert (Approval NO)))

(defrule CHAP7_5
(type_of_bankruptcy chapter7)
(Outlook  NN)
(Time  Med)
=>
(assert (DecideRate HH))
(assert (Approval HD)))

(defrule CHAP7_6
(type_of_bankruptcy chapter7)
(Outlook  NN)
(Time  Far)
=>
(assert (DecideRate HHH))
(assert (Approval YES)))

(defrule CHAP7_7
(type_of_bankruptcy chapter7)
(Outlook  NNN)
(Time  Rec)
=>
(assert (DecideRate H))
(assert (Approval NO)))

(defrule CHAP7_8
(type_of_bankruptcy chapter7)
(Outlook  NNN)
(Time  Med)
=>
(assert (DecideRate H))
(assert (Approval NO)))

(defrule CHAP7_9
(type_of_bankruptcy chapter7)
(Outlook  NNN)
(Time  Far)
=>
(assert (DecideRate A))
(assert (Approval YES)))

(defrule CHAP7_10
(type_of_bankruptcy chapter7)
(Outlook  NNNN)
(Time  Rec)
=>
(assert (DecideRate A))
(assert (Approval NO)))

(defrule CHAP7_11
(type_of_bankruptcy chapter7)
(Outlook  NNNN)
(Time  Med)
=>
(assert (DecideRate L))
(assert (Approval NO)))

(defrule CHAP7_12
(type_of_bankruptcy chapter7)
(Outlook  NNNN)
(Time  Far)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP7_13
(type_of_bankruptcy chapter7)
(Outlook  A)
(Time  Rec)
=>
(assert (DecideRate L))
(assert (Approval HD)))

(defrule CHAP7_14
(type_of_bankruptcy chapter7)
(Outlook  A)
(Time  Med)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP7_15
(type_of_bankruptcy chapter7)
(Outlook  A)
(Time  Far)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP7_16
(type_of_bankruptcy chapter7)
(Outlook  PPPP)
(Time  Rec)
=>
(assert (DecideRate L))
(assert (Approval HD)))

(defrule CHAP7_17
(type_of_bankruptcy chapter7)
(Outlook  PPPP)
(Time  Med)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP7_18
(type_of_bankruptcy chapter7)
(Outlook  PPPP)
(Time  Far)
=>
(assert (DecideRate LLL))
(assert (Approval YES)))

(defrule CHAP7_19
(type_of_bankruptcy chapter7)
(Outlook  PPP)
(Time  Rec)
=>
(assert (DecideRate LL))
(assert (Approval NO)))

(defrule CHAP7_20
(type_of_bankruptcy chapter7)
(Outlook  PPP)
(Time  Med)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP7_21
(type_of_bankruptcy chapter7)
(Outlook  PPP)
(Time  Far)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP7_22
(type_of_bankruptcy chapter7)
(Outlook  PP)
(Time  Rec)
=>
(assert (DecideRate LL))
(assert (Approval HD)))

(defrule CHAP7_23
(type_of_bankruptcy chapter7)
(Outlook  PP)
(Time  Med)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP7_24
(type_of_bankruptcy chapter7)
(Outlook  PP)
(Time  Far)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP7_25
(type_of_bankruptcy chapter7)
(Outlook  P)
(Time  Rec)
=>
(assert (DecideRate L))
(assert (Approval HD)))

(defrule CHAP7_26
(type_of_bankruptcy chapter7)
(Outlook  P)
(Time  Med)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP7_27
(type_of_bankruptcy chapter7)
(Outlook  P)
(Time  Far)
=>
(assert (DecideRate LLL))
(assert (Approval YES)))


;*************************************
;            chapter 13 FAM          *
;*************************************

(defrule CHAP13_1
(type_of_bankruptcy chapter13)
(Outlook  N)
(Time  Rec)
=>
(assert (DecideRate HHH))
(assert (Approval NO)))

(defrule CHAP13_2
(type_of_bankruptcy chapter13)
(Outlook  N)
(Time  Med)
=>
(assert (DecideRate HHH))
(assert (Approval NO)))

(defrule CHAP13_3
(type_of_bankruptcy chapter13)
(Outlook  N)
(Time  Far)
=>
(assert (DecideRate HH))
(assert (Approval NO)))

(defrule CHAP13_4
(type_of_bankruptcy chapter13)
(Outlook  NN)
(Time  Rec)
=>
(assert (DecideRate HH))
(assert (Approval HD)))

(defrule CHAP13_5
(type_of_bankruptcy chapter13)
(Outlook  NN)
(Time  Med)
=>
(assert (DecideRate HHH))
(assert (Approval NO)))

(defrule CHAP13_6
(type_of_bankruptcy chapter13)
(Outlook  NN)
(Time  Far)
=>
(assert (DecideRate HHH))
(assert (Approval YES)))

(defrule CHAP13_7
(type_of_bankruptcy chapter13)
(Outlook  NNN)
(Time  Rec)
=>
(assert (DecideRate HH))
(assert (Approval HD)))

(defrule CHAP13_8
(type_of_bankruptcy chapter13)
(Outlook  NNN)
(Time  Med)
=>
(assert (DecideRate H))
(assert (Approval NO)))

(defrule CHAP13_9
(type_of_bankruptcy chapter13)
(Outlook  NNN)
(Time  Far)
=>
(assert (DecideRate A))
(assert (Approval HD)))

(defrule CHAP13_10
(type_of_bankruptcy chapter13)
(Outlook  NNNN)
(Time  Rec)
=>
(assert (DecideRate A))
(assert (Approval NO)))

(defrule CHAP13_11
(type_of_bankruptcy chapter13)
(Outlook  NNNN)
(Time  Med)
=>
(assert (DecideRate L))
(assert (Approval HD)))

(defrule CHAP13_12
(type_of_bankruptcy chapter13)
(Outlook  NNNN)
(Time  Far)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP13_13
(type_of_bankruptcy chapter13)
(Outlook  A)
(Time  Rec)
=>
(assert (DecideRate A))
(assert (Approval NO)))

(defrule CHAP13_14
(type_of_bankruptcy chapter13)
(Outlook  A)
(Time  Med)
=>
(assert (DecideRate A))
(assert (Approval HD)))

(defrule CHAP13_15
(type_of_bankruptcy chapter13)
(Outlook  A)
(Time  Far)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP13_16
(type_of_bankruptcy chapter13)
(Outlook  PPPP)
(Time  Rec)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP13_17
(type_of_bankruptcy chapter13)
(Outlook  PPPP)
(Time  Med)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP13_18
(type_of_bankruptcy chapter13)
(Outlook  PPPP)
(Time  Far)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP13_19
(type_of_bankruptcy chapter13)
(Outlook  PPP)
(Time  Rec)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule CHAP13_20
(type_of_bankruptcy chapter13)
(Outlook  PPP)
(Time  Med)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP13_21
(type_of_bankruptcy chapter13)
(Outlook  PPP)
(Time  Far)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP13_22
(type_of_bankruptcy chapter13)
(Outlook  PP)
(Time  Rec)
=>
(assert (DecideRate LLL))
(assert (Approval NO)))

(defrule CHAP13_23
(type_of_bankruptcy chapter13)
(Outlook  PP)
(Time  Med)
=>
(assert (DecideRate LLL))
(assert (Approval HD)))

(defrule CHAP13_24
(type_of_bankruptcy chapter13)
(Outlook  PP)
(Time  Far)
=>
(assert (DecideRate LLL))
(assert (Approval YES)))

(defrule CHAP13_25
(type_of_bankruptcy chapter13)
(Outlook  P)
(Time  Rec)
=>
(assert (DecideRate LLL))
(assert (Approval HD)))

(defrule CHAP13_26
(type_of_bankruptcy chapter13)
(Outlook  P)
(Time  Med)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule CHAP13_27
(type_of_bankruptcy chapter13)
(Outlook  P)
(Time  Far)
=>
(assert (DecideRate LLL))
(assert (Approval YES)))





;*************************************
;     Decide Outlook FAM             *
;*************************************

(defrule decide_outlook_1
(CreditScore  Neg)
(DTI  Neg)
(LTV  Neg)
=>
(assert (DecideOutlook NNNN)))

(defrule decide_outlook_2
(CreditScore  Neg)
(DTI  Neg)
(LTV  Avg)
=>
(assert (DecideOutlook NNN)))

(defrule decide_outlook_3
(CreditScore  Neg)
(DTI  Neg)
(LTV  Pos)
=>
(assert (DecideOutlook NNN)))

(defrule decide_outlook_4
(CreditScore  Neg)
(DTI  Avg)
(LTV  Neg)
=>
(assert (DecideOutlook NNN)))

(defrule decide_outlook_5
(CreditScore  Neg)
(DTI  Avg)
(LTV  Avg)
=>
(assert (DecideOutlook NN)))

(defrule decide_outlook_6
(CreditScore  Neg)
(DTI  Avg)
(LTV  Pos)
=>
(assert (DecideOutlook N)))

(defrule decide_outlook_7
(CreditScore  Neg)
(DTI  Pos)
(LTV  Neg)
=>
(assert (DecideOutlook N)))

(defrule decide_outlook_8
(CreditScore  Neg)
(DTI  Pos)
(LTV  Avg)
=>
(assert (DecideOutlook NN)))

(defrule decide_outlook_9
(CreditScore  Neg)
(DTI  Pos)
(LTV  Pos)
=>
(assert (DecideOutlook N)))

(defrule decide_outlook_10
(CreditScore  Avg)
(DTI  Neg)
(LTV  Neg)
=>
(assert (DecideOutlook NN)))

(defrule decide_outlook_11
(CreditScore  Avg)
(DTI  Neg)
(LTV  Avg)
=>
(assert (DecideOutlook N)))

(defrule decide_outlook_12
(CreditScore  Avg)
(DTI  Neg)
(LTV  Pos)
=>
(assert (DecideOutlook A)))

(defrule decide_outlook_13
(CreditScore  Avg)
(DTI  Avg)
(LTV  Neg)
=>
(assert (DecideOutlook P)))

(defrule decide_outlook_14
(CreditScore  Avg)
(DTI  Avg)
(LTV  Avg)
=>
(assert (DecideOutlook A)))

(defrule decide_outlook_15
(CreditScore  Avg)
(DTI  Avg)
(LTV  Pos)
=>
(assert (DecideOutlook P)))

(defrule decide_outlook_16
(CreditScore  Avg)
(DTI  Pos)
(LTV  Neg)
=>
(assert (DecideOutlook A)))

(defrule decide_outlook_17
(CreditScore  Avg)
(DTI  Pos)
(LTV  Avg)
=>
(assert (DecideOutlook P)))

(defrule decide_outlook_18
(CreditScore  Avg)
(DTI  Pos)
(LTV  Pos)
=>
(assert (DecideOutlook P)))

(defrule decide_outlook_19
(CreditScore  Pos)
(DTI  Neg)
(LTV  Neg)
=>
(assert (DecideOutlook P)))

(defrule decide_outlook_20
(CreditScore  Pos)
(DTI  Neg)
(LTV  Avg)
=>
(assert (DecideOutlook PP)))

(defrule decide_outlook_21
(CreditScore  Pos)
(DTI  Neg)
(LTV  Pos)
=>
(assert (DecideOutlook P)))

(defrule decide_outlook_22
(CreditScore  Pos)
(DTI  Avg)
(LTV  Neg)
=>
(assert (DecideOutlook PP)))

(defrule decide_outlook_23
(CreditScore  Pos)
(DTI  Avg)
(LTV  Avg)
=>
(assert (DecideOutlook PP)))

(defrule decide_outlook_24
(CreditScore  Pos)
(DTI  Avg)
(LTV  Pos)
=>
(assert (DecideOutlook PPP)))

(defrule decide_outlook_25
(CreditScore  Pos)
(DTI  Pos)
(LTV  Neg)
=>
(assert (DecideOutlook PPP)))

(defrule decide_outlook_26
(CreditScore  Pos)
(DTI  Pos)
(LTV  Avg)
=>
(assert (DecideOutlook PPPP)))

(defrule decide_outlook_27
(CreditScore  Pos)
(DTI  Pos)
(LTV  Pos)
=>
(assert (DecideOutlook PPPP)))




;*****************************************
;   Late Payments 30-60 Family Issues    *
;*****************************************

(defrule late_payments_30-60_family_1
(type_of_late_payments 30-60_family)
(Outlook  N)
(Frequency one)
=>
(assert (DecideRate H))
(assert (Approval NO)))

(defrule late_payments_30-60_family_2
(type_of_late_payments 30-60_family)
(Outlook  N)
(Frequency two-three)
=>
(assert (DecideRate HH))
(assert (Approval NO)))

(defrule late_payments_30-60_family_3
(type_of_late_payments 30-60_family)
(Outlook  N)
(Frequency four)
=>
(assert (DecideRate HHH))
(assert (Approval HD)))

(defrule late_payments_30-60_family_4
(type_of_late_payments 30-60_family)
(Outlook  NN)
(Frequency one)
=>
(assert (DecideRate H))
(assert (Approval NO)))

(defrule late_payments_30-60_family_5
(type_of_late_payments 30-60_family)
(Outlook  NN)
(Frequency two-three)
=>
(assert (DecideRate H))
(assert (Approval NO)))

(defrule late_payments_30-60_family_6
(type_of_late_payments 30-60_family)
(Outlook  NN)
(Frequency four)
=>
(assert (DecideRate A))
(assert (Approval HD)))

(defrule late_payments_30-60_family_7
(type_of_late_payments 30-60_family)
(Outlook  NNN)
(Frequency one)
=>
(assert (DecideRate A))
(assert (Approval NO)))

(defrule late_payments_30-60_family_8
(type_of_late_payments 30-60_family)
(Outlook  NNN)
(Frequency two-three)
=>
(assert (DecideRate L))
(assert (Approval NO)))

(defrule late_payments_30-60_family_9
(type_of_late_payments 30-60_family)
(Outlook  NNN)
(Frequency four)
=>
(assert (DecideRate L))
(assert (Approval HD)))

(defrule late_payments_30-60_family_10
(type_of_late_payments 30-60_family)
(Outlook  NNNN)
(Frequency one)
=>
(assert (DecideRate A))
(assert (Approval YES)))

(defrule late_payments_30-60_family_11
(type_of_late_payments 30-60_family)
(Outlook  NNNN)
(Frequency two-three)
=>
(assert (DecideRate A))
(assert (Approval NO)))

(defrule late_payments_30-60_family_12
(type_of_late_payments 30-60_family)
(Outlook  NNNN)
(Frequency four)
=>
(assert (DecideRate A))
(assert (Approval HD)))

(defrule late_payments_30-60_family_13
(type_of_late_payments 30-60_family)
(Outlook  A)
(Frequency one)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule late_payments_30-60_family_14
(type_of_late_payments 30-60_family)
(Outlook  A)
(Frequency two-three)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule late_payments_30-60_family_15
(type_of_late_payments 30-60_family)
(Outlook  A)
(Frequency four)
=>
(assert (DecideRate LL))
(assert (Approval HD)))

(defrule late_payments_30-60_family_16
(type_of_late_payments 30-60_family)
(Outlook  PPPP)
(Frequency one)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule late_payments_30-60_family_17
(type_of_late_payments 30-60_family)
(Outlook  PPPP)
(Frequency two-three)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule late_payments_30-60_family_18
(type_of_late_payments 30-60_family)
(Outlook  PPPP)
(Frequency four)
=>
(assert (DecideRate LL))
(assert (Approval HD)))

(defrule late_payments_30-60_family_19
(type_of_late_payments 30-60_family)
(Outlook  PPP)
(Frequency one)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule late_payments_30-60_family_20
(type_of_late_payments 30-60_family)
(Outlook  PPP)
(Frequency two-three)
=>
(assert (DecideRate LL))
(assert (Approval YES)))

(defrule late_payments_30-60_family_21
(type_of_late_payments 30-60_family)
(Outlook  PPP)
(Frequency four)
=>
(assert (DecideRate LL))
(assert (Approval HD)))

(defrule late_payments_30-60_family_22
(type_of_late_payments 30-60_family)
(Outlook  PP)
(Frequency one)
=>
(assert (DecideRate A))
(assert (Approval YES)))

(defrule late_payments_30-60_family_23
(type_of_late_payments 30-60_family)
(Outlook  PP)
(Frequency two-three)
=>
(assert (DecideRate A))
(assert (Approval YES)))

(defrule late_payments_30-60_family_24
(type_of_late_payments 30-60_family)
(Outlook  PP)
(Frequency four)
=>
(assert (DecideRate LL))
(assert (Approval HD)))

(defrule late_payments_30-60_family_25
(type_of_late_payments 30-60_family)
(Outlook  P)
(Frequency one)
=>
(assert (DecideRate LLL))
(assert (Approval YES)))

(defrule late_payments_30-60_family_26
(type_of_late_payments 30-60_family)
(Outlook  P)
(Frequency two-three)
=>
(assert (DecideRate L))
(assert (Approval YES)))

(defrule late_payments_30-60_family_27
(type_of_late_payments 30-60_family)
(Outlook  P)
(Frequency four)
=>
(assert (DecideRate LL))
(assert (Approval YES)))


(deffacts startup
	(start))