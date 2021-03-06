/*
 Copyright [2016] [Taqdir Ali]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

 */
package org.uclab.mm.datamodel.ic.dataadapter.testcases;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.uclab.mm.datamodel.AbstractDataBridge;
import org.uclab.mm.datamodel.DataAccessInterface;
import org.uclab.mm.datamodel.DatabaseStorage;
import org.uclab.mm.datamodel.ic.UserRecognizedEmotion;
import org.uclab.mm.datamodel.ic.dataadapter.UserRecognizedEmotionAdapter;

/**
 * This is a class for testing the insertion, fetching, and update of UserRecognizedEmotion
 * @author Taqdir Ali
 *
 */
public class UserRecognizedEmotionAdapterTest {

	/**
	 * This is function for testing the insertion, fetching, and update of UserRecognizedEmotion 
	 */
	@Test
	public void test() {
		
		/* Preparing input object for insertion*/
		UserRecognizedEmotion objOuterUserRecognizedEmotion = new UserRecognizedEmotion();
		UserRecognizedEmotion objInnerUserRecognizedEmotion = new UserRecognizedEmotion();
		List<UserRecognizedEmotion> objListUserRecognizedEmotion = new  ArrayList<UserRecognizedEmotion>();
		
		objOuterUserRecognizedEmotion.setUserId(2L);
		objOuterUserRecognizedEmotion.setEmotionLabel("Happiness");
		objOuterUserRecognizedEmotion.setStartTime("2016 12 12 02:45:05");
	
		/* Testing of insertion function*/
		 DataAccessInterface objDAInterface = new UserRecognizedEmotionAdapter();
         AbstractDataBridge objADBridge = new DatabaseStorage(objDAInterface);
         List<String> lstResponse = objADBridge.SaveUserRecognizedEmotion(objOuterUserRecognizedEmotion);
         if(lstResponse.size() == 2)
         {
        	 /* Testing of fetching function*/
        	 objInnerUserRecognizedEmotion.setUserId(2L);
        	 objInnerUserRecognizedEmotion.setRequestType("LatestByUser");
        	 DataAccessInterface objDAInterfaceRetrieval = new UserRecognizedEmotionAdapter();
             AbstractDataBridge objADBridgeRetrieval = new DatabaseStorage(objDAInterfaceRetrieval);
        	 objListUserRecognizedEmotion = objADBridgeRetrieval.RetriveUserRecognizedEmotion(objInnerUserRecognizedEmotion);
        	 objInnerUserRecognizedEmotion = objListUserRecognizedEmotion.get(0);
         }
         
         assertEquals(objOuterUserRecognizedEmotion.getEmotionLabel(), objInnerUserRecognizedEmotion.getEmotionLabel());
	}

}
