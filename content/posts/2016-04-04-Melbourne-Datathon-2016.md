layout: post
title: "Melbourne Datathon 2016 - 4th Place"
date: 2016-05-20
categories: hackathon

<img alt="" src="/static/img/postimg/Kaggle_Image.PNG" style="width: 100%;">

The Melbourne Datathon 2016 is a hackathon which was organised by the Melbourne data science meet up group as way to bring data scientists together by solving real world problems. The event started with an introductory night on the 21st of April with sneak peak at the dataset, followed by a full hack day on the 23rd which was held in the Telstra Gurrowa Innovation Lab.
​	
The dataset contained job ads extracted from the <a href="www.seek.com.au">Seek</a> website which is used by companies for recruitment. The competition was broken in two parts, the first part was a challenge to extract interesting insights from the data where the top 5 teams would present their results.

The second part was a predictive modelling competition which was hosted on the data science website Kaggle. The objective was to classify job ads as "Hospitality and Tourism" class or not using the data provided as well as additional external sources.  

I decided to compete in the second part of the competition as I wanted to apply some of the machine learning techniques I had recently learnt.

## Part 1 - Data Cleaning 

As this was a natural language processing (NLP) problem, I spent a large amount of time scanning through the text data and identifying misspellings and redundancy in text for example, "full time permanent" is the same as "full time". Below is in exert from the code which shows the extent of the cleaning used in this competition.


	# Cleaning Function
	def clean_raw_job_type(s):
	s = s.lower()
	s = s.replace("  "," ")
	s = re.sub("[^a-zA-Z]", " ",s)
	s = s.replace("  "," ")
	s = s.replace("   "," ")
	s = s.replace("    "," ")
	s = s.replace("  "," ")
	s = re.sub(" [a-z] ","",s)
	s = s.rstrip()
	s = s.lstrip()
	
	# Full Time Clean
	s = s.replace("fulltime","full time")
	s = s.replace("full time permanent","full time")
	s = s.replace("permanent full time","full time")
	s = s.replace("full time temporary contract","full time")
	s = s.replace("full time position","full time")
	s = s.replace("full time experienced","full time")
	s = s.replace("worktype full time","full time")
	s = s.replace("work type full time","full time")
	s = s.replace("full time regular","full time")
	s = s.replace("full time flexible","full time")
	
	words = s.split()                                             
	
	# 5. Remove stop words
	meaningful_words = [w for w in words if not w in stops]   
	
	return " ".join(meaningful_words)

## Part 2 - Data Processing

The second part of the competition was spent transforming the newly processed data. One of the processing techniques for natural language processing is to apply Stemming or Lemmatization. The purpose of both of these techniques is to reduce the words into their root form. After testing out both techniques, I found Lemmatization to work slightly better then stemming.


    # Lemma is the best out of porter and snowball
    lemma = WordNetLemmatizer()
    stops = set(stopwords.words("english"))
    
    def lemma_tokens(tokens, lemma):
        lemmatized = []
        for item in tokens:
            lemmatized.append(lemma.lemmatize(item))
        return lemmatized


Once the text had been cleaned and simplified, there are still additional steps, this is because machine learning models can't process raw text directly. The strategy then was to convert the text into numbers using a technique called Bag of Words. The way Bag of Words works is by creating a column for each unique word in the corpus and assigning a "1" if a word is present and "0" otherwise. In addition, I used modified version which factors in the frequency of this words occurring across the corpus and adjusting the weighting down if the word occurs often. Luckily Scikit-learn package has a simple function which does the majority of the heavy lifting as shown below.

    tfidf_vectorizer = TfidfVectorizer(ngram_range=(1, 2),min_df=2,use_idf=1,smooth_idf=1,sublinear_tf=1,
                stop_words = 'english')
    tfidf_vectorizer.fit(train_X)
    train_X_tfidf =  tfidf_vectorizer.transform(train_X)
    test_X_tfidf = tfidf_vectorizer.transform(test_X)


## Part 3 - Modelling

After the data had been processed into the appropriate format, it was now time to start the modelling process. The main models I tested for this competition included Logistic Regression, Naive Bayes, Support Vector Machine, Random Forecast and Gradient Boosted Trees. Although some of the methods I attempted to use were quite advance, the method which ended up with the best accuracy was the relatively simple Logistic Regression.

    from sklearn.linear_model import LogisticRegressionCV
    logreg = LogisticRegressionCV(class_weight = 'balanced',cv = 5,scoring='roc_auc',n_jobs=-1,random_state=42)
    logreg.fit(train_X_tsvd, train_Y)
    print "Score %.5f +/- %.5f " % (logreg.scores_[1].mean(),logreg.scores_[1].std())


## Concluding Remarks

In conclusion, this competition was an interesting experience and allowed me to utilize my text mining skills as well as applying a variety of machine learning algorithms. Despite the advancements in algorithms, in some cases, a simple model is the most effective. This reiterates the bias and variance tradeoff and how some models 