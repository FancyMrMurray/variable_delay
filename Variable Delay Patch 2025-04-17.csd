<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

;Hi!! thanks for downloading and looking at this. My CsOptions is empty because I use CSoundQT, which overrides those options to make configuring ins and outs a lot easier. If you are new to CSound, there are great rescources for basic operation on https://flossmanual.csound.com.
;Take the 20 minutes or so to read the intro and so forth - knowing the basic function will make it easier to adapt this code to work with your setup. Happy Music Making!

instr 1				;;;Variable Delay Pedal

	aLeft, aRight		ins

	iMaximumDelayTime = 20																;maximum delay time

	iAmp				= 1																	;amplification value (exp) DO WE NEED?
	kMinLength		ctrl7 2, 27, 0.05, 5											;minimum clip length (exp)
						outvalue "kMinLength", kMinLength
	kLengthWidth		= kMinLength*4													;the distance between min & max length (linear)
	kHighBound		= iMaximumDelayTime												;the maximum Start Time in the random range
						outvalue "kHighBound", kHighBound
	
	kDrySend			ctrl7 2, 28, 0, 1												;amount of dry signal going through								
	
	kStartTime		random 0.0015, kHighBound										;generate a random Start Time (ksmps/sr: the min value allowed)
	kLength			random kMinLength, kMinLength+kLengthWidth					;generate a random Length 
	
	AudioClip:																			;BEGIN REINIT HERE

	kGrainEnv			linseg 0, 0.005, 0, 0.05, 1, i(kLength)-0.11, 1, 0.05, 0, 0.005, 0
						outvalue "kGrainEnv", kGrainEnv

						print i(kStartTime), i(kLength)								;print for Debugging
	
	aBuf1				delayr iMaximumDelayTime, 1 									;read the end of the delay stream running on left channel		
	aTapL				deltap i(kStartTime)											;tap into delay stream at our random time		
						delayw aLeft+aTapL*0.5											;write audio into the start of the delay stream
				
	aBuf2				delayr iMaximumDelayTime, 1									;read the end of the delay stream running on right channel
	aTapR				deltap i(kStartTime)											;tap into delay stream at our random time
						delayw aRight+aTapR*0.5											;write audio into the start of the delay stream
					
						timout 0, i(kLength), skipReinit								;if our clip isn't done yet, go to "skipReinit:"
		
						rireturn															;end any reinitializations here
		
						reinit AudioClip													;reinitialize everything 
		
	skipReinit:																			;skip the reinit block
	
	gaAux1L			= aLeft*kDrySend + aTapL*kGrainEnv							;send to aux left 	;normally i'd use += but this
	gaAux1R			= aRight*kDrySend + aTapR*kGrainEnv							;send to aux right 	;is monophonic so...
	
endin

instr 2

	aL					compress2 gaAux1L, gaAux1L, -80, -12, -6, 5, 0.01, 0.1, 0.1	;compressor left
	aR					compress2 gaAux1R, gaAux1R, -80, -12, -6, 5, 0.01, 0.1, 0.1	;compressor right

	itim				date																;get date																	
	Stim   			dates itim														;get date as string
	Syear				strsub Stim, 20, 24												;extract year
	Smonth   			strsub Stim, 4, 7												;extract month
	Sday     			strsub Stim, 8, 10												;extract day as string
	iday    			strtod Sday														;calculate day as number
	Shor     			strsub Stim, 11, 13												;extract hour
	Smin    			strsub Stim, 14, 16												;extract minute
	Ssec    			strsub Stim, 17, 19												;extract seconds
	Sfilnam  			sprintf  "outs - %s %02d %s %s-%s-%s.wav", Syear, iday, Smonth, Shor, Smin, Ssec	;create string for filename
	
						fout Sfilnam, -1, aL, aR										;save to file
						outs aL, aR														;send to speakers

endin

;;;;;;as the High Bound decreases, the Dry and Wet Sounds get closer together (less delay)
;;;;;;as the Min length decreases the snippets get more frantic

</CsInstruments>
<CsScore>
i1 0 3600																					;activate the delay component
i2 0 3600																					;activate the master channel and outs
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
 <bsbObject version="2" type="BSBScope">
  <objectName/>
  <x>10</x>
  <y>10</y>
  <width>425</width>
  <height>200</height>
  <uuid>{746f4e6d-ef1d-4a92-bc6b-00f327c58312}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>-255.00000000</value>
  <type>scope</type>
  <zoomx>2.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <mode>0.00000000</mode>
  <triggermode>NoTrigger</triggermode>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>kMinLength</objectName>
  <x>10</x>
  <y>300</y>
  <width>80</width>
  <height>25</height>
  <uuid>{58ea6f2e-095c-4973-9fa0-2ed6483cafdf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>2.544</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>true</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>kHighBound</objectName>
  <x>100</x>
  <y>300</y>
  <width>80</width>
  <height>25</height>
  <uuid>{24554812-d2d6-4851-b9c6-0f55eb21be0f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>20.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>true</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>13</x>
  <y>285</y>
  <width>80</width>
  <height>25</height>
  <uuid>{bdbb0fa9-efb7-4b80-8938-d9966ed2187b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>kminlength</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>110</x>
  <y>281</y>
  <width>80</width>
  <height>25</height>
  <uuid>{c82d5135-68d6-4650-b376-dac7b24e5497}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>kHighBound</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
