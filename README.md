# Quantifying the roles of vomiting, diarrhea, and resident vs. staff in norovirus transmission by studying norovirus outbreaks in 107 U.S. LTCFs

## Background
Norovirus outbreaks are common in long term care facilities (LTCFs), where older LTCF residents experience an increased risk of severe illness and mortality, effective prevention and control measures are urgently needed. Current control measures are based on general infection control principles including ward closure, specific regimes and case isolation, however the efficacy of these measures in controlling norovirus is not well quantified. By examining transmission patterns and factors associated with increased transmissibility, we can facilitate progress on interventions aimed at reducing the burden of norovirus diseases in LTCFs. 

For this study, we examined how factors of clinical symptoms (e.g. vomit, diarrhea) and individual information (resident vs. staff) associated with individual case infectiousness, which can be used to inform parameter estimates in mathematical models. It can also lead to a better understanding of disease spread and the value of specific control measures (e.g., if vomiters are found to be more infectious than non-vomiters, this could lead support for control measures aimed at reducing vomiting, such as antiemetic treatment for vomiters). 

## Data Source

We used data that we collected from LTCF (nursing homes, skilled nursing facilities, and assisted living facilities) norovirus outbreaks occurring in the US between December 1, 2013 and April 15, 2020. These data were requested from state health departments that participate in NoroSTAT, a collaborative network of twelve state health departments and CDC created to improve timeliness and completeness of norovirus outbreak reporting. Information such as age, gender, symptom onset/resolution dates, and symptoms was requested for all cases. We have received 108 line lists, including 3,385 total cases, from five state health departments. All line lists were completed by LTCFs in conjunction with local and state public health officials.

## Methods
Individual case infectiousness is the outcome of interest, which was be quantified by estimating each case’s individual effective reproduction number, R<sub>Ei</sub>, or the expected number of secondary cases that an individual, i, generates in an outbreak. We estimated R<sub>Ei</sub> using the Wallinga-Teunis (WT) method developed by [Wallinga et al](https://academic.oup.com/aje/article/160/6/509/79472), a method that uses the difference in symptom onset dates between cases (obtained from line lists) and the probability distribution of the serial interval (the time between symptom onset in primary cases and the secondary cases they generate) to calculate the relative likelihood that cases with earlier onset dates infected cases with later onset dates. We used a probability distribution for the serial interval that was derived from a [previous study](https://wwwnc.cdc.gov/eid/article/15/1/08-0299_article). 

We first examined the associations between R<sub>Ei</sub> and the following dichotomous predictor variables: vomiting, diarrhea, and case type (resident vs. staff). Second, we examined the association between case infectiousness and an interaction between vomiting and diarrhea. Third, we examined associations between R<sub>Ei</sub> and the following variables: being an index case or not, season of case's sympton onset. For these analyses, we used weighted multivariate mixed linear regression models with random intercepts for outbreaks. We incorporated the uncertainty of each R<sub>Ei</sub> estimate by using inverse variance weighting.
the final linear mixed model can be found below:

<p align="center">
    log R<sub>Ei</sub>= &beta;<sub>0</sub>+b<sub>0i</sub>+&beta;<sub>1</sub> Diarrhea<sub>ij</sub>+&beta;<sub>2</sub> Vomiting<sub>ij</sub>+&beta;<sub>3</sub> Resident<sub>ij</sub>+e<sub>ij</sub>
</p>

where log R<sub>Ei</sub> represents the estimated log R<sub>Ei</sub> of the jth case from the ith outbreak, b<sub>0i</sub> represents the random slope for the ith outbreak, and e<sub>ij</sub> represents residual heterogeneity of the jth case from the ith outbreak not explained by the model. The residual heterogeneity, e<sub>ij</sub>, and random slope, b<sub>0i</sub>, are assumed to be independent and identically distributed with mean zero and their respective variances. Cases from the same outbreak were assigned the same random effect, whereas cases from different outbreaks were assumed to be independent. Final coefficient estimates and 95% confidence intervals were exponentiated to show the relationships between average R<sub>Ei</sub> (rather than log R<sub>Ei</sub>) and the variables in the model. All statistical analyses were performed using the EpiEstim and metafor packages in R software version 4.0.3. 

## Main Results

