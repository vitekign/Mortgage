Welcome to the Expert-System-with-Fuzzy-Logic wiki!

# Mortgage Approval and Rate Generator Expert System 

### Introduction and Background

With the rise of the intelligent systems, more and more tasks are being delegated to machines. The mortgage industry is not an exception. All mortgage applicants are processed through software systems, which decide the eventual rate and approval status. Such systems are called "mortgage underwriters", and are used overwhelmingly in the mortgage industry. However, some cases, which fall between strong approval and strong disapproval are usually passed to loan officers. The loan officers try to collect more information, with regard to each specific case. After all additional information is collected and analyzed, they decide whether to approve or not. Usually, such decisions are hugely influenced by intuition and experience of the loan officers. 
	
#The main purpose of this project falls into two main categories: 
###1.Knowledge Engineering

The initial step was to choose a topic and find a knowledge expert. In the beginning, I wanted to go with some problems in healthcare; however, I could not find the topic which would take crisp input and produce crisp output. Since my sister's husband worked as a loan officer at the time, I instead decided to do a "mortgage underwriter" expert system. Taking into consideration the fact that I did not have any clue over mortgage approval's fundamentals, it was a big task to understand how the process of decision making is done and which applicant's information is necessary for the whole system to work. 

###2.Mortgage Underwriter Expert System.

The second step was to take all acquired knowledge concerning the mortgage industry and convert it into an expert system. The main purpose of the Mortgage Underwriter Expert System is to collect all necessary information from an applicant and decide whether to approve or disapprove his/her application. If the system decides that the applicant's case is approved, then the system also calculates the appropriate mortgage rate. The necessary applicant's information is the following: credit card score, recurring monthly debt (everything is included - student loans, etc.), gross monthly income (income before taxes), the appraised/market value of the house and the amount of the downpayment. All follow-up questions are asked as a response to the earlier answered questions. 

#Knowledge Engineering

Without thorough, complete and precise information it is impossible to build an expert system. So, the first step was to contact my expert engineer, trying to explain what I am about to build. The engineer, for this project, was Seth Robinson, at the time working as a loan officer. During our first talk, he explained to me the life cycle of mortgage decision making. The first step is to collect information and pass it to a mortgage underwriter. If the mortgage underwriter gives a positive YES/NO, then no additional human help is needed to finalize the deal. However, in some cases, the mortgage underwriter cannot decide whether to approve or not. In such cases, the applications are passed to loan officers for the final consideration and decision. 

After being able to see the big picture, we moved towards constructing a flowchart of the whole process. We quickly figured out that the most significant data which can profoundly affect the decision tree path is an applicant's credit score. The lowest range of score is between 450 and up to 640. If the applicant falls in this range then it indicates one of the following cases:

1. The applicant has a history of bankruptcies. 

	There are two types of bankruptcies: chapter 7 and chapter 13.  		
	Neither of them is fatal; however, more information is needed to make a final decision. At this 
	point, the applicant must answer how long ago his/her bankruptcies took place. If 
	they occurred during the last two years, then the system automatically blocks such an	
	applicat. However, if it happened more than 2 years ago, the system must employ 
        **fuzzy logic** and decide whether to approve or not.  

2. The applicant has a history of making late payments. 

   1.  30-to-60-day late payments.
	If the applicant falls into this category then the client needs to answer 
	how many times this type of late payment has occurred.  
	If it happened more than 4 times, then it is an automatic denial. 
	If the applicant has been late 4 or fewer times, then **fuzzy logic** needs to be 
	employed. Also, extenuating circumstances such as family issues 
	must be considered towards a more positive overall outlook.  

   2.  60-to-90-day late payments 
        This case is considered to be worse than the previous one. 
	If the applicant has acquired more than two records of this kind,
        then it is an automatic denial. On the other hand, 
	if the applicant has only 1 or 2 records of this type, 
        then **fuzzy logic** must be utilized. Also, 
	extenuating circumstances such as family issues must be 
	taken into consideration towards a more positive overall outlook. 

   3.   90-and-more-day late payments 
        If the applicant has acquired any number of such late payments, 
	then it triggers an automatic denial. 


3. The applicant has collection accounts. 

	1. Medical Collection Accounts.

		Medical Collection Accounts, often, occur because of the mistakes made by the insurance
		companies. Due to some corporate and technical breaches, insurance companies end 
		up not paying their customers' medical bills. If the applicant has knowledge about an 
		existent collection account and is taking all necessary steps to resolve the issue, then
                it does not introduce negative overall outlook. In such 
		cases, fuzzy logic needs to be incorporated and the final decision to be 
		considered based on all of the information provided. 
		However, if the application does not know about collection account's existence and is not 
		about to take any steps to resolve the issue, then it is an automatic denial. 

	2. Non-Medical, so-called "Irresponsible/Immature" collection accounts. 

		This case is considered to be one of the worst possible cases. This sub-branch 
		means that the applicant is not willing to pay the monthly bills. 
		If the applicant does not ignore such collection accounts and has set up a 
		payment plan to pay them off, then the applicant's application gets passed 
		directly to a loan officer for additional inquiries and considerations. 
		However, if the applicant is not willing to begin paying them off, then it is 
		an automatic denial. 
		If the applicant agrees to pay off one of the biggest collection accounts, then the 
		case gets passed to the loan officer; however, the chances of approval are very
		slim. 


##Mortgage Expert 

Seth Robinson, at the time worked as a Senior Mortgage Loan Originator, Envoy Mortgage.
His daily job was to call potential mortgage leads and convert them into sales. Also, maintained relationships with realtors and potential clients for future sales.

cell-phone: (404) 518-4587                      email: robinsoncet@gmail.com


##Simplifications and Constrains

1. Considering the size of this type of expert system in production, I had no choice but to constrain my application to cover only one credit score range. However, I chose to implement the most difficult range which goes from 450 up to 640 score points. The applicants who fall in this range, usually have to meet a number of extra requirements, which have to be taken into consideration and thoroughly analyzed. 
2. Due to the time constraints, I implemented only 3 sub-trees which lead to the mortgage approval decision and rate assignment. This includes: chapter-7 bankruptcy, chapter-13 bankruptcy and 30-60-day late payments, with extenuating circumstances like 'family issues'. It might not seem a lot; however, my knowledge expert spent around 3 hours just on filling up the FAM rules for this small part of fully implemented mortgage expert system. 
3. The system does not make a decision whether to assign a 15-year mortgage or instead go with a 30-year offer. 
4. Considering that Credit Rating, LTV and DTI are used in each possible scenario, I decided to employ fuzzy logic and convert these three crisp input values into one overall score. This way I could decrease the number of FAM cases in each sub-tree by order of 3. For example, in chapter-7 case, instead of having an 81-case FAM, I downsized it to 27 cases. However, I am not sure if by doing so I did not lose some precision and sensitivity. 



##Expert System Design


1. To better understand the organization of the system, please refer to the Flow Chart. During multiple phone conversations with my expert, I was making numerous notes and small flow-charts. After the most important information was collected, I turned everything into one flowchart. It turns out that a nicely done flow chart can serve as one of the best tools for this type of projects. After finishing constructing the flowchart, I moved to coding and began converting everything to clips. 

2. The first task of the system is to collect the most necessary information concerning the applicant's case. This information includes: the applicant's credit score, recurring monthly debt, gross monthly income, a market value of the house and the amount of the down payment. As soon as this information is provided, the system calculates the DTI and LTV ratios.

          DTI ratio = [recurring monthly debt] / [gross monthly income] 

          LTV ratio = ([market value of the house] - [downpayment]) / [market value of the house] 

After calculating DTI and LTV, the system uses fuzzy logic to calculate the OVERALL OUTLOOK points, which are applied to every eventual decision. I did it in order to simplify the job of my knowledge expert, instead of doing 81 cases at each sub-branch, he only needed to fill out 27 possibilities. Diagram 2.1, 2.2, and 2.3 show how I made a range of fuzzy inputs. After conversion, the fuzzy logic does its job and produces a crisp value based on diagram 2.4. After getting a crisp value of OVERALL OUTLOOK points, I run them again through the 'fuzzy set definition' for OUTLOOK. Doing this, I associate a crisp value with an appropriate parameter: NNNN | NNN | NN | N | A | P | PP | PPP | PPPP. I do this process in order to be able to use my crisp value later, in fuzzy logic, which decides the approval status and mortgage rate, in each sub-tree.

##1.1 Process of calculating the OVERALL OUTLOOK points. 
![outlook_fuzzy](https://cloud.githubusercontent.com/assets/3220686/20918786/8d910df6-bb4d-11e6-86d7-7c7a93187567.png)

##2.1 Credit Score Fuzzy Set
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918872/fffa7d14-bb4d-11e6-8093-ca11830d1880.jpg">

##2.2 DTI [debt to income] Fuzzy Set 
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918890/11a182a6-bb4e-11e6-85e1-6214a93e2ae0.png">

##2.3 LTV [loan to value] Fuzzy Set
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918899/1d9527e8-bb4e-11e6-978f-df40ed887061.png">

##2.4 Overall Outlook [loan to value]
<img width="800" src="https://cloud.githubusercontent.com/assets/3220686/20918926/4238a75a-bb4e-11e6-9d6c-0b149f9dbb88.png">

##2.5 How long ago the last bankruptcy happened Fuzzy Set.
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918934/4d4a13e0-bb4e-11e6-97ce-1c19d52c21d1.png">

##1.2 The process of decision-making for bankruptcy chapter 7/13 sub-tree. 
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918955/5ea76908-bb4e-11e6-9359-2c8c6f31e699.png">

After additional case-specific questions have been asked, the system calculates the eventual mortgage rate and decides whether to approve the applicant's application or not. To utilize fuzzy logic, the system uses OVERALL OUTLOOK points and from one to n instances of additional fuzzy sets, from a corresponding sub-tree. For example, to make a final decision in a chapter-7 case,  the system uses OVERALL OUTLOOK points (2.4) and the fuzzy set which summarizes how long ago the last bankruptcy happened (2.5). 
The process for calculating the bankruptcy chapter-13 case is very similar. It is also based on
OVERALL OUTLOOKS points (2.4) and a corresponding value for the time when the last bankruptcy occurred (2.5). 


##1.3 The process of decision making for 30-60-day-late payments with family-related extenuating circumstances. 
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918959/64d1ef74-bb4e-11e6-81ba-004c6cd40654.png">

In this case, fuzzy logic is employed to calculate the final decision and mortgage rate for the case when the applicant has made a 30-60-day late credit card payments, taking into consideration family-related extenuating circumstances. The frequency fuzzy set stands for the number of late payments acquired by the applicant (2.7). To make the final decision the fuzzy logic is utilized using OVERALL OUTLOOK points (2.4) and frequency fuzzy set (2.7).

##2.7 The number of 30-60 day late credit card payments Fuzzy Set. 
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918973/74d5b4b4-bb4e-11e6-9cf5-39de0594434b.png">

##2.8 Rate Fuzzy Set. 
<img width="600" src="https://cloud.githubusercontent.com/assets/3220686/20918987/7f409022-bb4e-11e6-98cc-4a9878dfdada.png">

##2.9 Approval Fuzzy Set. 
<img width="400" src="https://cloud.githubusercontent.com/assets/3220686/20918999/8bf672dc-bb4e-11e6-9806-f71a4065e203.png">

To make the final decision the system runs all of the corresponding values through the Rate Fuzzy Set (2.8) and Approval Fuzzy Set (2.9). After this step, the system saves two crisp values for the rate and for the approval status. For the rate, the system does not need to convert the value into another type. However, for the approval status, the system converts the crisp output into one of three cases: Approved, Human Decision or Denial, as shown in Approval Fuzzy Set (2.9). 

If the application is approved, the system congratulates the applicant and informs about a corresponding mortgage rate. 

If the application is needed to be reviewed by a loan officer, then the system informs the applicant without showing a corresponding mortgage rate. 

If the application is denied, then the system informs the applicant without showing any other information. 


#Sample scenarios.
##Scenario 3.1
<img width="600" alt="scenario_1" src="https://cloud.githubusercontent.com/assets/3220686/20919016/9ea07040-bb4e-11e6-8e38-fff83172e97c.png">

##Scenario 3.2
<img width="600" alt="scenario_2" src="https://cloud.githubusercontent.com/assets/3220686/20919030/aae316be-bb4e-11e6-8111-95ab79414e66.png">

##Scenario 3.3
<img width="600" alt="scenario_3" src="https://cloud.githubusercontent.com/assets/3220686/20919036/b19bdf36-bb4e-11e6-91b6-b2d66a3efca6.png">

##Scenario 3.4
<img width="600" alt="scenario_4" src="https://cloud.githubusercontent.com/assets/3220686/20919043/b8c26c62-bb4e-11e6-9962-e240c1525b45.png">
