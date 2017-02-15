FROM		java:7

ENV     	DEBIAN_FRONTEND noninteractive

ENV		JMETER_VERSION	3.1
ENV		JMETER_HOME	/jmeter
ENV		JMETER_DOWNLOAD_URL  http://mirrors.tuna.tsinghua.edu.cn/apache/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV TZ=America/New_York

# Set the timezone.
RUN echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# install needed debian packages & clean up
RUN		apt-get update && \
		apt-get install -y --no-install-recommends curl tar ca-certificates unzip iputils-ping wget telnet default-jre-headless && \
		apt-get clean autoclean && \
        	apt-get autoremove --yes && \
        	rm -rf /var/lib/{apt,dpkg,cache,log}/

# download and extract jmeter 
RUN		mkdir -p ${JMETER_HOME} && \
		curl -L --silent ${JMETER_DOWNLOAD_URL} | tar -xz --strip=1 -C ${JMETER_HOME} && \
		curl -L --silent http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.2.1.zip -o /tmp/jmeter-plugins-standard.zip && \
		unzip -o -d ${JMETER_HOME} /tmp/jmeter-plugins-standard.zip && \
		rm /tmp/jmeter-plugins-standard.zip

#COPY jmeter /jmeter

#ADD runload.sh /runload.sh

#RUN chmod +x /runload.sh

VOLUME ['/jmeter']

WORKDIR	${JMETER_HOME}

#CMD /runload.sh
# Example run command:
# bin/jmeter -n -t /jmeter/your-test.jmx -l /log/result_log.jtl;
